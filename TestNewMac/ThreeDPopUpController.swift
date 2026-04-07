//
//  TourPopUpController.swift
//
//
//  Created by Abhang Mane @Goldmedal on 18/07/25.
//

import UIKit
import ModelIO
import SceneKit
import SwiftGLTF
import ARKit
import RealityKit
import RealityFoundation
import WebKit

class ThreeDPopUpController: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var sceneVwLbl: SCNView!
    @IBOutlet weak var arVwLbl: ARView!
    @IBOutlet weak var webViewLbl: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        blurBackground()
        loadWebView()
//        loadGLBModel()
//        loadUSDZ()
//        loadARKitModel()
        
    }
    
   
    //Blur Effect...
    func blurBackground() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            mainView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mainView.addSubview(blurEffectView)
            mainView.sendSubviewToBack(blurEffectView)
        }
    }
    
    @IBAction func closePopupPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func loadWebView(){
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewLbl.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: webViewLbl.topAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewLbl.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: webViewLbl.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewLbl.trailingAnchor)
        ])
        
        let urlString = """
        https://sketchfab.com/models/da99d6e3e278429fb73f2d45ae678e9e/embed\
        ?autostart=1\
        &ui_infos=0\
        &ui_controls=0\
        &ui_stop=0\
        &ui_watermark=0\
        &ui_watermark_link=0\
        &ui_hint=0\
        &ui_help=0\
        &ui_settings=0\
        &ui_annotations=0\
        &ui_fullscreen=0
        """
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }

    func makeScene(from container: Container) throws -> SCNScene {
        let scene = SCNScene()
        let document = container.document

        for mesh in document.meshes {
            for primitive in mesh.primitives {

                guard let positionIndex = primitive.attributes[.POSITION] else { continue }
                let accessor = try positionIndex.resolve(in: document)
                let vertexData = try container.data(for: accessor)

                let vertexSource = SCNGeometrySource(
                    data: vertexData,
                    semantic: .vertex,
                    vectorCount: accessor.count,
                    usesFloatComponents: true,
                    componentsPerVector: 3,
                    bytesPerComponent: 4,
                    dataOffset: 0,
                    dataStride: 12
                )

                var element: SCNGeometryElement

                if let indicesIndex = primitive.indices {
                    let indexAccessor = try indicesIndex.resolve(in: document)
                    let indexData = try container.data(for: indexAccessor)

                    element = SCNGeometryElement(
                        data: indexData,
                        primitiveType: .triangles,
                        primitiveCount: indexAccessor.count / 3,
                        bytesPerIndex: 2
                    )
                } else {
                    element = SCNGeometryElement(
                        indices: Array(0..<accessor.count),
                        primitiveType: .triangles
                    )
                }

                let geometry = SCNGeometry(sources: [vertexSource], elements: [element])
                let node = SCNNode(geometry: geometry)
                scene.rootNode.addChildNode(node)
            }
        }

        return scene
    }

    
    func loadGLBModel() {

        do {
            guard let url = Bundle.main.url(forResource: "MATRIX_SURFACE_02_GLB", withExtension: "glb") else {
                return
            }

            let container = try Container(url: url)
            let scene = try makeScene(from: container)

            sceneVwLbl.scene = scene
            sceneVwLbl.autoenablesDefaultLighting = true
            sceneVwLbl.allowsCameraControl = true

        } catch {
            print("GLB loading failed:", error)
        }
    }
    
    private func setupsceneVwLbl() {
        sceneVwLbl = SCNView(frame: view.bounds)
        sceneVwLbl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(sceneVwLbl)

        sceneVwLbl.allowsCameraControl = true
        sceneVwLbl.backgroundColor = .black
        
        // Important
        sceneVwLbl.autoenablesDefaultLighting = true
    }


    private func loadUSDZ() {
        guard let url = Bundle.main.url(forResource: "MATRIX_SURFACE_02_GLB", withExtension: "usdz") else {
            fatalError("USDZ file not found")
        }

        do {
            let scene = try SCNScene(url: url)
            sceneVwLbl.scene = scene
//            addLighting(to: scene)
            sceneVwLbl.scene?.lightingEnvironment.contents = "ferndale_studio_01_4k.hdr"
            sceneVwLbl.scene?.lightingEnvironment.intensity = 2.0
            
        } catch {
            print("Failed to load USDZ:", error)
        }
    }
    
    private func addLighting(to scene: SCNScene) {
        
        // Omni light
        let omniLight = SCNLight()
        omniLight.type = .omni
        omniLight.intensity = 2000
        
        let omniNode = SCNNode()
        omniNode.light = omniLight
        omniNode.position = SCNVector3(0, 5, 10)
        scene.rootNode.addChildNode(omniNode)
        
        // Ambient light
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 500
        
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        scene.rootNode.addChildNode(ambientNode)
    }

    func loadARKitModel(){
        let arView = ARView(frame: view.bounds)
        arVwLbl.addSubview(arView)
        loadARModel(into: arView)
    }
    
    private func loadARModel(into arView: ARView) {

        guard let root = try? Entity.load(named: "MATRIX_SURFACE_02_GLB.usdz") else {
            return
        }

        let modelEntity = root.findEntity(named: root.name) as? ModelEntity
            ?? root.children.compactMap { $0 as? ModelEntity }.first

        guard let model = modelEntity else {
            print("No ModelEntity found")
            return
        }

        model.generateCollisionShapes(recursive: true)

        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(root)

        arView.scene.addAnchor(anchor)
        arView.installGestures([.rotation, .scale], for: model)
       }
}

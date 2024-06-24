//
//  ImmersiveView.swift
//  BallSort
//
//  Created by André Salla on 20/06/24.
//

import SwiftUI
import SceneKit
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(scene)
                // Occluded floor
                let floor = ModelEntity(
                    mesh: .generatePlane(width: 100, depth: 100),
                    materials: [OcclusionMaterial()]
                )
                floor.generateCollisionShapes(recursive: false)
                floor.components[PhysicsBodyComponent.self] = .init(
                  massProperties: .default,
                  mode: .static
                )
                content.add(floor)
                
                guard let tube = try? await ModelEntity.Tube.generateTube(radius: 0.1, thick: 0.01, height: 0.5, position: .vertical) else { return }
                
                let sphere = ModelEntity(mesh: .generateSphere(radius: 0.05), materials: [SimpleMaterial()])
                sphere.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.05)], isStatic: false))
                sphere.components.set(PhysicsBodyComponent(massProperties: .default, material: .default))
                
                sphere.position = SIMD3(x: 0.1, y: 0.6, z: -1.98)
                tube.position = SIMD3(x: 0, y: 0.25, z: -2)
                
                content.add(tube)
                content.add(sphere)
                
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}

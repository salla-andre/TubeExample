//
//  TubeEntity.swift
//  BallSort
//
//  Created by André Salla on 23/06/24.
//

import RealityKit
import SwiftUI

extension ModelEntity {
    @MainActor
    enum Tube {

        enum Position {
            case vertical
            case horiziontal
        }
        
        static func generateTube(
            radius: Float,
            thick: Float,
            height: Float,
            position: Tube.Position = .horiziontal
        ) async throws -> some Entity {
            let diameter = CGFloat(radius * 2.0)
            let internalDiameter = diameter - CGFloat(thick * 2.0)
            let innerShape = Circle().size(width: internalDiameter, height: internalDiameter)
            let roundShape = Circle().size(width: diameter, height: diameter)
            
            let hollowCircle = roundShape
                .symmetricDifference(innerShape.offset(x: CGFloat(thick), y: CGFloat(thick)))
            
            var options = MeshResource.ShapeExtrusionOptions()
            options.extrusionMethod = .linear(depth: height)
            
            let mesh = try await MeshResource(
                extruding: hollowCircle.path(
                    in:CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter)
                ),
                extrusionOptions: options
            )
            
            let entity = ModelEntity(mesh: mesh, materials: [SimpleMaterial(color: .gray, isMetallic: false)])
            
            let shape = try await ShapeResource.generateStaticMesh(from: mesh)
            
            let colision = CollisionComponent(shapes: [shape], isStatic: false)
            
            entity.components.set(colision)
            
            entity.components.set(PhysicsBodyComponent(
              massProperties: .default,
              mode: .static
            ))
            
            if position == .vertical {
                entity.move(to: simd_float4x4(simd_quatf(.init(angle: Angle2D(degrees: 90), axis: .x))), relativeTo: nil)
            }
            
            return entity
        }
    }
}

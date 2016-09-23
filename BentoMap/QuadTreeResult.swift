//
//  QuadTreeResult.swift
// BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public enum QuadTreeResult<NodeData, Rect: BentoRect, Coordinate: BentoCoordinate> {

    case Single(node: QuadTreeNode<NodeData, Coordinate>)
    case Multiple(nodes: [QuadTreeNode<NodeData, Coordinate>])

    /// The average of the origin points of all the nodes
    /// contained in the QuadTree.
    public var originCoordinate: Coordinate {
        let originCoordinate: Coordinate
        switch self {
        case let .Single(node):
            originCoordinate = node.originCoordinate
        case let .Multiple(nodes):
            var x: CGFloat = 0.0
            var y: CGFloat = 0.0
            for node in nodes {
                x += node.originCoordinate.x
                y += node.originCoordinate.y
            }
            x /= CGFloat(nodes.count)
            y /= CGFloat(nodes.count)
            originCoordinate = Coordinate(x: x, y: y)
        }
        return originCoordinate
    }

    /// The smallest possible rectangle that contains the node(s) contained in this QuadTree.
    public var contentRect: Rect {
        let origin: Coordinate
        let size: CGSize
        switch  self {
        case let .Single(node: node):
            origin = node.originCoordinate
            size = CGSize()
        case let .Multiple(nodes: nodes):
            var minCoordinate = CGPoint(x: CGFloat.max, y: CGFloat.max)
            var maxCoordinate = CGPoint(x: CGFloat.min, y: CGFloat.min)
            for node in nodes {
                minCoordinate.x = min(minCoordinate.x, node.originCoordinate.x)
                minCoordinate.y = min(minCoordinate.y, node.originCoordinate.y)
                maxCoordinate.x = max(maxCoordinate.x, node.originCoordinate.x)
                maxCoordinate.y = max(maxCoordinate.y, node.originCoordinate.y)
            }
            origin = Coordinate(x: minCoordinate.x, y: minCoordinate.y)
            // slightly pad the size to make sure all nodes are contained
            size = CGSize(width: abs(minCoordinate.x - maxCoordinate.x) + 0.001,
                             height: abs(minCoordinate.y - maxCoordinate.y) + 0.001)
        }
        return Rect(originCoordinate: origin, size: size)
    }

}

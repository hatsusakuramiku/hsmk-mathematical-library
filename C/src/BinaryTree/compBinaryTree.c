/*
 * Copyright  2024 hatsusakuramiku
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stdio.h>
#include "compBinaryTree.h"

#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "constDef.h"

/**
 * @brief Initializes a complete binary tree with the given number of nodes.
 *
 * @param nodeNum The number of nodes in the binary tree.
 * @return A pointer to the initialized complete binary tree, or NULL if nodeNum is 0.
 */
CompleteBinaryTree *compBinaryTreeInit(unsigned int nodeNum) {
    if (nodeNum == 0) {
        return NULL;
    }

    // Allocate memory for the complete binary tree
    CompleteBinaryTree *tree = (CompleteBinaryTree *) malloc(sizeof(CompleteBinaryTree));
    PWARNING_RETURN_MALLOC(tree);

    // Allocate memory for the node array
    tree->nodeArray = (TreeNode *) malloc(sizeof(TreeNode) * nodeNum);
    tree->nodeCount = 0;
    tree->nodeNum = nodeNum;

    return tree;
}

/**
 * @brief Destroys a complete binary tree.
 *
 * @param tree A pointer to the complete binary tree to be destroyed.
 */
void compBinaryTreeDestroy(CompleteBinaryTree **tree) {
    if (tree == NULL || *tree == NULL) {
        return;
    }

    // Clear the tree
    compBinaryTreeClear(*tree);

    // Free the tree memory
    FREE(*tree);
    FREE(tree);
}

/**
 * @brief Clears a complete binary tree.
 *
 * @param tree A pointer to the complete binary tree to be cleared.
 */
void compBinaryTreeClear(CompleteBinaryTree *tree) {
    if (tree == NULL) {
        return;
    }

    // Free the node array memory
    FREE(tree->nodeArray);
    tree->nodeNum = 0;
}

/**
 * @brief Adds a node to a complete binary tree.
 *
 * @param tree A pointer to the complete binary tree.
 * @param data The data to be added to the node.
 * @param dataTypeSize The size of the data type.
 */
void compBinaryTreeAdd(CompleteBinaryTree *tree, TreeNodeData data, size_t dataTypeSize) {
    if (tree == NULL) {
        return;
    }

    if (tree->nodeCount == tree->nodeNum) {
        printf("Binary tree is full!\n");
        return;
    }

    const int i = tree->nodeCount;
    int parentIndex = i / 2;
    if (i % 2 == 0) {
        parentIndex--;
    }

    // Create a new node and add it to the tree
    tree->nodeArray[i] = (TreeNode){
        .data = data,
        .dataTypeSize = dataTypeSize,
        .leftChildIndex = -1,
        .rightChildIndex = -1,
        .parentIndex = parentIndex
    };

    if (parentIndex < 0) {
        tree->nodeCount++;
        return;
    }

    if (i % 2 == 0) {
        tree->nodeArray[parentIndex].leftChildIndex = i;
    } else {
        tree->nodeArray[parentIndex].rightChildIndex = i;
    }

    tree->nodeCount++;
}

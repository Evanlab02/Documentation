# Binary Trees

A Binary Tree is a type of data structure in which each node has at most two children (left child and right child). Binary trees are used to implement binary search trees and binary heaps, and are used for efficient searching and sorting. A binary tree is a special case of a K-ary tree, where k is 2. Common operations for binary trees include insertion, deletion, and traversal. The difficulty of performing these operations varies if the tree is balanced and also whether the nodes are leaf nodes or branch nodes. For **balanced trees** the depth of the left and right subtrees of every node differ by 1 or less. This allows for a predictable **depth** also known as **height**. This is the measure of a node from root to leaf, where root is 0 and sebsequent nodes are (1,2..n). This can be expressed by the integer part of log2(n) where n is the number of nodes in the tree.

```c
        g                  s                  9
       / \                / \                / \
      b   m              f   u              5   13
     / \                    / \                /  \
    c   d                  t   y              11  15
```

The operations performed on trees requires searching in one of two main ways: Depth First Search and Breadth-first search. **Depth-first search (DFS)** is an algorithm for traversing or searching tree or graph data structures. One starts at the root and explores as far as possible along each branch before backtracking. There are three types of depth first search traversal: **pre-order** visit, left, right, **in-order** left, visit, right, **post-order** left, right, visit. **Breadth-first search (BFS)** is an algorithm for traversing or searching tree or graph structures. In level-order, where we visit every node on a level before going to a lower level.

**DFS - pre-order**
- Visit
- Left
- Right

**DFS - in-order**
- Left
- Visit
- Right

**DFS - post-order**
- Left
- Right
- Visit

## Python examples

### Depth First Search - Pre-Order

```python
"""Contains example of depth first search with pre-order technique."""


class TreeNode:
    """Binary tree node."""

    def __init__(self, value: int):
        """Constructor for the binary tree node."""
        self.value: int = value
        self.left: TreeNode | None = None
        self.right: TreeNode | None = None


def pre_order_traversal(node: TreeNode | None):
    """Method for pre-order-traversal."""
    if node is not None:
        print(node.value, end=' ')
        pre_order_traversal(node.left)
        pre_order_traversal(node.right)


# Example Tree:
#
#     1
#    / \
#   2   3
#  / \   \
# 4   5   6

# Example usage:
if __name__ == "__main__":
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left.left = TreeNode(4)
    root.left.right = TreeNode(5)
    root.right.right = TreeNode(6)
    pre_order_traversal(root)
```

### Depth First Search - In-Order

```python
"""Contains example of depth first search with in-order technique."""


class TreeNode:
    """Binary tree node."""

    def __init__(self, value: int):
        """Constructor for the binary tree node."""
        self.value: int = value
        self.left: TreeNode | None = None
        self.right: TreeNode | None = None


def in_order_traversal(node: TreeNode | None):
    """Method for in-order traversal."""
    if node is not None:
        in_order_traversal(node.left)
        print(node.value, end=' ')
        in_order_traversal(node.right)


# Example Tree:
# Example Tree:
#
#     1
#    / \
#   2   3
#  / \   \
# 4   5   6

# Example usage:
if __name__ == "__main__":
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left.left = TreeNode(4)
    root.left.right = TreeNode(5)
    root.right.right = TreeNode(6)
    in_order_traversal(root)
```

### Depth First Search - Post-Order

```python
"""Contains example of depth first search with post-order technique."""


class TreeNode:
    """Binary tree node."""

    def __init__(self, value: int):
        """Constructor for the binary tree node."""
        self.value: int = value
        self.left: TreeNode | None = None
        self.right: TreeNode | None = None


def post_order_traversal(node: TreeNode | None):
    """Method for post-order traversal."""
    if node is not None:
        post_order_traversal(node.left)
        post_order_traversal(node.right)
        print(node.value, end=' ')


# Example Tree:
# Example Tree:
#
#     1
#    / \
#   2   3
#  / \   \
# 4   5   6

# Example usage:
if __name__ == "__main__":
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left.left = TreeNode(4)
    root.left.right = TreeNode(5)
    root.right.right = TreeNode(6)
    post_order_traversal(root)
```

### Breadth First Search

```python
"""Contains example of breadth first search."""

from collections import deque


class TreeNode:
    """Binary tree node."""

    def __init__(self, value: int):
        """Constructor for the binary tree node."""
        self.value: int = value
        self.left: TreeNode | None = None
        self.right: TreeNode | None = None


def bfs_traversal(root: TreeNode | None):
    """Contains method for bfs traversal."""
    if root is None:
        return

    queue = deque([root])

    while queue:
        current = queue.popleft()
        print(current.value, end=' ')

        if current.left is not None:
            queue.append(current.left)
        if current.right is not None:
            queue.append(current.right)


# Example Tree:
#
#     1
#    / \
#   2   3
#  / \   \
# 4   5   6

# Example usage:
if __name__ == "__main__":
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left.left = TreeNode(4)
    root.left.right = TreeNode(5)
    root.right.right = TreeNode(6)
    bfs_traversal(root)
```

## C Example - DFS Pre-Order

```C
// Libraries
#include <stdio.h>
#include <stdlib.h>

// TreeNode struct
typedef struct node
{
  int val;
  struct node * left;
  struct node * right;
} node_t;

// Function declarations.
void insert(node_t * tree,int val);
void print_tree(node_t * current);
void printDFS(node_t * current);

/**
 * Entrypoint for the program.
 */
int main()
{
  node_t * test_list = (node_t *) malloc(sizeof(node_t));
  /* set values explicitly, alternative would be calloc() */
  test_list->val = 0;
  test_list->left = NULL;
  test_list->right = NULL;

  insert(test_list,5);
  insert(test_list,8);
  insert(test_list,4);
  insert(test_list,3);

  printDFS(test_list);
  printf("\n");
}

void insert(node_t * tree, int val)
{
  if (tree->val == 0)
  {
    /* insert on current (empty) position */
    tree->val = val;
  }
  else
  {
    if (val < tree->val)
    {
      /* insert left */
      if (tree->left != NULL)
      {
        insert(tree->left, val);
      }
      else
      {
        tree->left = (node_t *) malloc(sizeof(node_t));
        /* set values explicitly, alternative would be calloc() */
        tree->left->val = val;
        tree->left->left = NULL;
        tree->left->right = NULL;
      }
    }
    else
    {
      if (val >= tree->val)
      {
        /* insert right */
        if (tree->right != NULL)
        {
          insert(tree->right,val);
        }
        else
        {
          tree->right = (node_t *) malloc(sizeof(node_t));
          /* set values explicitly, alternative would be calloc() */
          tree->right->val = val;
          tree->right->left = NULL;
          tree->right->right = NULL;
        }
      }
    }
  }
}

/* depth-first search */
void printDFS(node_t * current)
{
  /* change the code here */
  if (current == NULL)         return;   /* security measure */
  if (current != NULL)         printf("%d ", current->val);
  if (current->left != NULL)   printDFS(current->left);
  if (current->right != NULL)  printDFS(current->right);
}
```


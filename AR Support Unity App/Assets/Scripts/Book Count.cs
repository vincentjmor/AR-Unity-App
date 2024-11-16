using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class BookCount : MonoBehaviour
{
    public XRSocketInteractor socket;
    public void OnEnable()
    {
        socket.selectEntered.AddListener(OnObjectPlaced);
        socket.selectExited.AddListener(OnObjectRemoved);
    }

    public void OnDisable()
    {
        socket.selectEntered.RemoveListener(OnObjectPlaced);
        socket.selectExited.RemoveListener(OnObjectRemoved);
    }

    public void OnObjectPlaced(SelectEnterEventArgs args)
    {
        Debug.Log("Object placed in socket: " + args.interactableObject.transform.name);
        ThirdTaskBookshelf.numberOfBooksInShelf = ThirdTaskBookshelf.numberOfBooksInShelf + 1;
    }

    public void OnObjectRemoved(SelectExitEventArgs args)
    {
        Debug.Log("Object removed from socket.");
        ThirdTaskBookshelf.numberOfBooksInShelf = ThirdTaskBookshelf.numberOfBooksInShelf - 1;
    }
}

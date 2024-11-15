using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.Interaction.Toolkit;

public class ThirdTask : MonoBehaviour
{
    public XRSocketInteractor blueCanSocket;
    public XRSocketInteractor oragenCanSocket;
    public XRSocketInteractor redCanSocket;
    public XRSocketInteractor greenCanSocket;
    public Image image;
    public Color newColor = Color.green;

    void Start()
    {
        image = GetComponent<Image>();
    }

    // Update is called once per frame
    void Update()
    {
        // Check if the socket has an interactable in it
        if (blueCanSocket.hasSelection && oragenCanSocket.hasSelection && redCanSocket.hasSelection && greenCanSocket.hasSelection)
        {
            image.color = newColor;
        }
    }
}

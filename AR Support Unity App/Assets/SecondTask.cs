using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SecondTask : MonoBehaviour
{
    public Image image;
    public Color newColor = Color.green;
    // Example of a global boolean variable
    public static bool hasGrabbedMisplacedItem = false;

    void Start()
    {
        image = GetComponent<Image>();
    }


    // Update is called once per frame
    void Update()
    {
        if (hasGrabbedMisplacedItem)
        {
            image.color = newColor;
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.Interaction.Toolkit;

public class ThirdTaskBookshelf : MonoBehaviour
{
    public Image image;
    public Color newColor = Color.green;

    public static int numberOfBooksInShelf = 0;

    void Start()
    {
        image = GetComponent<Image>();
    }

    // Update is called once per frame
    void Update()
    {
        if (numberOfBooksInShelf > 1)
        {
            image.color = newColor;
        }
    }
}

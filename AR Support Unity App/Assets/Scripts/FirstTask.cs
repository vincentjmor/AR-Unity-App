using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FirstTask : MonoBehaviour
{
    public Camera mainCamera;
    public GameObject targetObject; // The GameObject to check for visibility
    public Image image;
    public Color newColor = Color.green;
    private bool hasCompletedTask = false;

    void Start()
    {
        image = GetComponent<Image>();
    }

    void Update()
    {
        if (mainCamera != null && targetObject != null)
        {
            Plane[] planes = GeometryUtility.CalculateFrustumPlanes(mainCamera);
            Renderer targetRenderer = targetObject.GetComponent<Renderer>();

            if (targetRenderer != null && GeometryUtility.TestPlanesAABB(planes, targetRenderer.bounds))
            {
                //Debug.Log("The object is within the camera's view frustum.");
                if (image != null && !hasCompletedTask)
                {
                    hasCompletedTask = true;
                    // Change the color of the Image component
                    image.color = newColor;
                    FindObjectOfType<SoundEffectPlayer>().PlaySound();
                }
            }
            //else
            //{
            //    Debug.Log("The object is outside the camera's view frustum.");
            //}
        }
        //else
        //{
        //    Debug.LogWarning("Camera or target object is not assigned or has no renderer.");
        //}
    }
}

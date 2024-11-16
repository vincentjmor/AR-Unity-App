using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class OutlineOnGrab : MonoBehaviour
{
    [SerializeField] private XRGrabInteractable grabInteractable;  // Reference to the XRGrabInteractable component
    [SerializeField] private Material socketOutlineMaterial;        // Exposed material field to assign in Inspector
    private string outlineProperty = "_Scale";                      // The correct shader property name (with the underscore)
    private float outlineOnValue = 1.03f;                           // Scale value for the outline when visible
    private float outlineOffValue = 0.0f;                          // Scale value for the outline when invisible

    void Start()
    {
        // Ensure the grab interactable is assigned in the Inspector
        if (grabInteractable == null)
        {
            Debug.LogError("GrabInteractable component is not assigned.");
            return;
        }

        // Check if the material is assigned in the Inspector
        if (socketOutlineMaterial == null)
        {
            Debug.LogError("Socket Outline material is not assigned in the Inspector.");
            return;
        }

        // Add listeners for when the book is grabbed or released
        grabInteractable.onSelectEntered.AddListener(OnGrab);
        grabInteractable.onSelectExited.AddListener(OnRelease);
    }

    private void OnGrab(XRBaseInteractor interactor)
    {
        if (socketOutlineMaterial != null)
        {
            // Log to confirm if the method is called
            Debug.Log("Book grabbed! Applying outline change to all objects with this material.");

            // Set the "_Scale" property in the shared material to make the outline visible
            socketOutlineMaterial.SetFloat(outlineProperty, outlineOnValue);

            Debug.Log("Outline is now visible. Setting " + outlineProperty + " to " + outlineOnValue);
        }
        else
        {
            Debug.LogError("Socket Outline material is missing!");
        }
    }

    private void OnRelease(XRBaseInteractor interactor)
    {
        if (socketOutlineMaterial != null)
        {
            // Log to confirm if the method is called
            Debug.Log("Book released! Hiding outline for all objects with this material.");

            // Set the "_Scale" property in the shared material to hide the outline
            socketOutlineMaterial.SetFloat(outlineProperty, outlineOffValue);

            Debug.Log("Outline is now hidden. Setting " + outlineProperty + " to " + outlineOffValue);
        }
        else
        {
            Debug.LogError("Socket Outline material is missing!");
        }
    }

    void OnDestroy()
    {
        // Remove listeners when the object is destroyed
        if (grabInteractable != null)
        {
            grabInteractable.onSelectEntered.RemoveListener(OnGrab);
            grabInteractable.onSelectExited.RemoveListener(OnRelease);
        }
    }
}
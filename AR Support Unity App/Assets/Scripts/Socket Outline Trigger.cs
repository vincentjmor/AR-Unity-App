using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class ToggleOutlineOnGrab : MonoBehaviour
{
    // Reference to the material
    [SerializeField] private Material socketOutlineMaterial;

    // Scale values for showing/hiding the outline
    private const float VisibleScale = 1.03f;
    private const float HiddenScale = 0f;

    private XRGrabInteractable grabInteractable;

    private void Start()
    {
        // Ensure the outline is hidden initially
        SetOutlineScale(HiddenScale);
    }

    private void OnEnable()
    {
        // Subscribe to grab events
        grabInteractable = GetComponent<XRGrabInteractable>();
        if (grabInteractable)
        {
            grabInteractable.selectEntered.AddListener(OnGrab);
            grabInteractable.selectExited.AddListener(OnRelease);
        }
    }

    private void OnDisable()
    {
        // Unsubscribe from grab events
        if (grabInteractable)
        {
            grabInteractable.selectEntered.RemoveListener(OnGrab);
            grabInteractable.selectExited.RemoveListener(OnRelease);
        }
    }

    private void OnGrab(SelectEnterEventArgs args)
    {
        // Set the outline scale to visible when grabbed
        SetOutlineScale(VisibleScale);
    }

    private void OnRelease(SelectExitEventArgs args)
    {
        // Set the outline scale to hidden when released
        SetOutlineScale(HiddenScale);
    }

    private void OnTriggerEnter(Collider other)
    {
        // Check if the object is entering the XR Socket Interactor
        if (other.GetComponent<XRSocketInteractor>())
        {
            // Set outline scale to hidden when touching an XR Socket Interactor
            SetOutlineScale(HiddenScale);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        // Check if the object is exiting the XR Socket Interactor
        if (other.GetComponent<XRSocketInteractor>())
        {
            // Set outline scale to visible when exiting the XR Socket Interactor
            SetOutlineScale(VisibleScale);
        }
    }

    private void SetOutlineScale(float scale)
    {
        if (socketOutlineMaterial != null)
        {
            socketOutlineMaterial.SetFloat("_Scale", scale);
        }
        else
        {
            Debug.LogWarning("Socket Outline Material is not assigned!");
        }
    }
}
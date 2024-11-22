using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class ToggleOutlineOnGrab : MonoBehaviour
{
    // Reference to the material
    [SerializeField] private Material socketOutlineMaterial;

    // Scale values for showing/hiding the outline
    private const float VisibleScale = 1.03f;
    private const float HiddenScale = 0f;

    private void Start()
    {
        // Ensure the outline is hidden initially
        SetOutlineScale(HiddenScale);
    }

    private void OnEnable()
    {
        // Subscribe to grab events
        var grabInteractable = GetComponent<XRGrabInteractable>();
        if (grabInteractable)
        {
            grabInteractable.selectEntered.AddListener(OnGrab);
            grabInteractable.selectExited.AddListener(OnRelease);
        }
    }

    private void OnDisable()
    {
        // Unsubscribe from grab events
        var grabInteractable = GetComponent<XRGrabInteractable>();
        if (grabInteractable)
        {
            grabInteractable.selectEntered.RemoveListener(OnGrab);
            grabInteractable.selectExited.RemoveListener(OnRelease);
        }
    }

    private void OnGrab(SelectEnterEventArgs args)
    {
        // Set the outline scale to visible
        SetOutlineScale(VisibleScale);
    }

    private void OnRelease(SelectExitEventArgs args)
    {
        // Set the outline scale to hidden
        SetOutlineScale(HiddenScale);
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
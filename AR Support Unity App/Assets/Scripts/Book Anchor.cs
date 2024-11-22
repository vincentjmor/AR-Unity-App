using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class BookGrabControl : MonoBehaviour
{
    [SerializeField] private XRGrabInteractable grabInteractable;  // Reference to XRGrabInteractable
    private Rigidbody rb;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();

        // Set the Rigidbody to Kinematic initially
        if (rb != null)
        {
            rb.isKinematic = true;
        }

        if (grabInteractable != null)
        {
            grabInteractable.selectEntered.AddListener(OnGrab);
            grabInteractable.selectExited.AddListener(OnRelease);
        }
    }

    private void OnDestroy()
    {
        if (grabInteractable != null)
        {
            grabInteractable.selectEntered.RemoveListener(OnGrab);
            grabInteractable.selectExited.RemoveListener(OnRelease);
        }
    }

    private void OnGrab(SelectEnterEventArgs args)
    {
        // When grabbed, disable isKinematic to allow physics interaction
        if (rb != null)
        {
            rb.isKinematic = false;
        }
    }

    private void OnRelease(SelectExitEventArgs args)
    {
        // When released, set isKinematic back to true
        if (rb != null)
        {
            rb.isKinematic = true;
        }
    }
}
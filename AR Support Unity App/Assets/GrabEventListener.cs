using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class GrabEventListener : MonoBehaviour
{
    private XRGrabInteractable grabInteractable;

    void Awake()
    {
        grabInteractable = GetComponent<XRGrabInteractable>();

        if (grabInteractable != null)
        {
            grabInteractable.selectEntered.AddListener(OnGrab);
            grabInteractable.selectExited.AddListener(OnRelease);
        }
    }

    private void OnGrab(SelectEnterEventArgs args)
    {
        Debug.Log("Object grabbed!");
        // Perform actions when grabbed, such as changing color, updating UI, etc.
    }

    private void OnRelease(SelectExitEventArgs args)
    {
        Debug.Log("Object released!");
        // Perform actions when released
    }

    private void OnDestroy()
    {
        // Unsubscribe to avoid memory leaks
        if (grabInteractable != null)
        {
            grabInteractable.selectEntered.RemoveListener(OnGrab);
            grabInteractable.selectExited.RemoveListener(OnRelease);
        }
    }
}

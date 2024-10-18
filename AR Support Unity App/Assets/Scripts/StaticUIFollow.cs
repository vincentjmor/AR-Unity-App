/*using UnityEngine;

public class CompassUI : MonoBehaviour
{
    public Transform playerCamera;  // Reference to the player's camera (headset in VR)
    public Transform pointOfInterest;  // Reference to the POI in the scene
    public RectTransform compassBar;  // The UI element representing the compass bar
    public RectTransform exclamationPoint;  // The UI element representing the exclamation point on the compass

    public float maxAngle = 90f;  // The maximum angle to show on the compass (half of the compass range)

    void Update()
    {
        // Calculate the direction from the player to the POI
        Vector3 toPOI = (pointOfInterest.position - playerCamera.position).normalized;
        Vector3 playerForward = playerCamera.forward;

        // Calculate the signed angle between the player's forward direction and the POI
        float angle = Vector3.SignedAngle(playerForward, toPOI, Vector3.up);

        // Clamp the angle within the range of the compass
        float clampedAngle = Mathf.Clamp(angle, -maxAngle, maxAngle);

        // Normalize the angle to the compass range (-1 to 1)
        float normalizedAngle = clampedAngle / maxAngle;

        // Map the normalized angle to a position on the compass bar
        float exclamationPointX = (compassBar.rect.width / 2) * normalizedAngle;

        // Set the exclamation point's position on the compass bar
        exclamationPoint.localPosition = new Vector3(exclamationPointX, exclamationPoint.localPosition.y, 0);
    }
}
*/
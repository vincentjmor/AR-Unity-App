/*using UnityEngine;
using UnityEngine.UI;

public class CompassBar : MonoBehaviour
{
    public RectTransform compassBar; // The UI Image representing the compass bar
    public Transform player; // Player's transform (could be AR camera or player object)
    public Transform[] pointsOfInterest; // List of points of interest in the world

    public float compassWidth = 500f; // Width of your compass bar in pixels
    public float maxCompassAngle = 90f; // Max field of view to display in the compass

    void Update()
    {
        // Loop through each point of interest
        foreach (Transform poi in pointsOfInterest)
        {
            // Calculate the direction to the POI relative to the player
            Vector3 directionToPOI = poi.position - player.position;
            float angleToPOI = Vector3.SignedAngle(player.forward, directionToPOI, Vector3.up);

            // Check if POI is within the player's view (maxCompassAngle)
            if (Mathf.Abs(angleToPOI) < maxCompassAngle)
            {
                // Convert angle to a normalized position (-1 to 1) on the compass
                float normalizedPosition = angleToPOI / maxCompassAngle;

                // Map normalized position to a pixel position on the compass bar
                float poiPositionOnCompass = normalizedPosition * (compassWidth / 2);

                // Create an indicator for the POI (or move an existing one)
                RectTransform poiIndicator = CreateOrMovePOIIndicator(poi);
                poiIndicator.anchoredPosition = new Vector2(poiPositionOnCompass, 0);
            }
        }
    }

    RectTransform CreateOrMovePOIIndicator(Transform poi)
    {
        // Create or move a UI indicator for the POI
        // Here, you would handle creating or reusing an indicator for the POI
        // For now, assume you have a placeholder for each POI's indicator
        // (e.g., create one if it doesn't exist yet)

        // Return a reference to the RectTransform of the POI indicator
        // In a real setup, you would instantiate or find this UI element
        return null; // Placeholder, you would replace this with the actual POI indicator
    }
}
 */
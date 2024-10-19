using UnityEngine;

public class DirectionIndicator : MonoBehaviour
{
    public Transform pointOfInterest;  // Assign the POI transform here

    void Update()
    {
        // Calculate the direction to the POI
        Vector3 directionToPOI = (pointOfInterest.position - transform.position).normalized;

        // Calculate the rotation needed to point towards the POI
        Quaternion targetRotation = Quaternion.LookRotation(directionToPOI);

        // Smoothly rotate the indicator towards the target direction
        transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * 5f);
    }
}

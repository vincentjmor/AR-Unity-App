using UnityEngine;

public class MoveUpDown : MonoBehaviour
{
    public float amplitude = 0.2f;  // The height of the movement
    public float speed = 2.0f;      // The speed of the up-and-down motion
    private Vector3 startPos;

    void Start()
    {
        // Store the starting position of the object
        startPos = transform.position;
    }

    void Update()
    {
        // Calculate the new Y position using Mathf.Sin for smooth oscillation
        float newY = startPos.y + Mathf.Sin(Time.time * speed) * amplitude;

        // Set the new position of the object
        transform.position = new Vector3(startPos.x, newY, startPos.z);
    }
}
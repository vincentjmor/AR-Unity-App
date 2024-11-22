using UnityEngine;

public class ObjectSpawner : MonoBehaviour
{
    // Public field to assign the object to spawn
    public GameObject objectToSpawn;

    // Public field to define spawn location
    public Transform spawnLocation;

    // Method to spawn the object when called
    public void SpawnObject()
    {
        // Check if an object and spawn location are assigned
        if (objectToSpawn != null && spawnLocation != null)
        {
            // Instantiate the object at the spawn location's position and rotation
            Instantiate(objectToSpawn, spawnLocation.position, spawnLocation.rotation);
        }
        else
        {
            Debug.LogError("No object or spawn location set.");
        }
    }
}
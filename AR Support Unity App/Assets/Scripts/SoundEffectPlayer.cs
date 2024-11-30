using UnityEngine;

public class SoundEffectPlayer : MonoBehaviour
{
    public AudioClip soundEffect; // Assign the sound effect in the Inspector
    private AudioSource audioSource;

    void Start()
    {
        // Get or add an AudioSource component to the GameObject
        audioSource = GetComponent<AudioSource>();
        if (audioSource == null)
        {
            audioSource = gameObject.AddComponent<AudioSource>();
        }

        // Set the AudioSource settings
        audioSource.playOnAwake = false; // Prevent the sound from playing automatically
        audioSource.clip = soundEffect; // Assign the clip to the AudioSource
    }

    // Call this method to play the sound
    public void PlaySound()
    {
        if (soundEffect != null)
        {
            audioSource.Play();
        }
        else
        {
            Debug.LogWarning("No sound effect assigned!");
        }
    }
}

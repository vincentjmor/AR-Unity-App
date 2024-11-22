using UnityEngine;

public class SettingsManager : MonoBehaviour
{
    public static SettingsManager Instance;

    // Define your colorblind mode settings (e.g., Normal, Protanopia, Deuteranopia, Tritanopia)
    public enum ColorblindMode { Normal, Protanopia, Deuteranopia, Tritanopia }
    public ColorblindMode CurrentMode = ColorblindMode.Normal;

    private void Awake()
    {
        // Ensure only one instance exists
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject); // Persist across scenes
        }
        else
        {
            Destroy(gameObject);
        }
    }
}

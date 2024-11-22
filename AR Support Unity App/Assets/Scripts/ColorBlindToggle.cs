using UnityEngine;

public class ColorblindToggle : MonoBehaviour
{
    public void SetColorblindMode(int modeIndex)
    {
        if (SettingsManager.Instance != null)
        {
            SettingsManager.Instance.CurrentMode = (SettingsManager.ColorblindMode)modeIndex;
            ApplyColorblindMode();
        }
    }

    private void ApplyColorblindMode()
    {
        // Apply the colorblind settings globally here
        switch (SettingsManager.Instance.CurrentMode)
        {
            case SettingsManager.ColorblindMode.Normal:
                Debug.Log("Normal mode activated.");
                // Add code to revert colors
                break;
            case SettingsManager.ColorblindMode.Protanopia:
                Debug.Log("Protanopia mode activated.");
                // Add code for Protanopia filter
                break;
            case SettingsManager.ColorblindMode.Deuteranopia:
                Debug.Log("Deuteranopia mode activated.");
                // Add code for Deuteranopia filter
                break;
            case SettingsManager.ColorblindMode.Tritanopia:
                Debug.Log("Tritanopia mode activated.");
                // Add code for Tritanopia filter
                break;
        }
    }
}

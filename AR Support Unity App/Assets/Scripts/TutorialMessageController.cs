using UnityEngine;

public class TutorialMessageController : MonoBehaviour
{
    public GameObject tutorialMessage;

    // Method to hide the tutorial message
    public void HideMessage()
    {
        tutorialMessage.SetActive(false);
    }
}

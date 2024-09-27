using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    public void LoadScene()
    {
        SceneManager.LoadScene("Grocery Store scene");
    }

    public void LoadScenes(string sceneName)
    {
        SceneManager.LoadScene(sceneName);
    }
}

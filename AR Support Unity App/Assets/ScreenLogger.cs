using UnityEngine;
using System.Collections.Generic;

public class ScreenLogger : MonoBehaviour
{
    private List<string> logs = new List<string>();
    private Vector2 scrollPosition;
    private bool isShowing = true;

    [SerializeField] private int maxLogs = 15;
    [SerializeField] private int fontSize = 14;
    [SerializeField] private float startDelay = 1.0f; // Delay in seconds before logging starts

    private bool loggingEnabled = false;

    private void Start()
    {
        // Start logging after a delay
        Invoke("EnableLogging", startDelay);
    }

    private void EnableLogging()
    {
        loggingEnabled = true;
        Application.logMessageReceived += HandleLog;
    }

    private void OnDisable()
    {
        Application.logMessageReceived -= HandleLog;
    }

    private void HandleLog(string logString, string stackTrace, LogType type)
    {
        if (!loggingEnabled) return;

        logs.Add(logString);

        if (logs.Count > maxLogs)
        {
            logs.RemoveAt(0);
        }
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            isShowing = !isShowing;
        }
    }

    private void OnGUI()
    {
        if (!isShowing) return;

        GUI.skin.label.fontSize = fontSize;

        // Position logs on the right side of the screen
        float width = Screen.width / 3;
        float height = Screen.height / 2;
        GUILayout.BeginArea(new Rect(Screen.width - width - 10, 10, width, height));

        scrollPosition = GUILayout.BeginScrollView(scrollPosition);

        foreach (string log in logs)
        {
            GUILayout.Label(log);
        }

        GUILayout.EndScrollView();
        GUILayout.EndArea();
    }
}

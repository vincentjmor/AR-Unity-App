using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace HeneGames.CookingSystem
{
    public class FoodAudioController : MonoBehaviour
    {
  
        private bool starCookingSound;

        [Header("Audio Settings")]
        [Range(-3f, 3f)]
        [SerializeField] private float audioPitch = 1.0f;
        [Range(0f, 1f)]
        [SerializeField] private float audioVolume = 1.0f;

        [Header("Audio Sources")]
        [SerializeField] private AudioSource audioSourceLoop;
        [SerializeField] private AudioSource audioSourceStartCooking;

        [Header("Start Sounds")]
        [SerializeField] private AudioClip startCookingSoundStove;
        [SerializeField] private AudioClip startCookingSoundDeepFryer;
        [SerializeField] private AudioClip startCookingSoundOven;

        [Header("Loop Sounds")]
        [SerializeField] private AudioClip loopSoundStove;
        [SerializeField] private AudioClip loopSoundOven;
        [SerializeField] private AudioClip loopSoundDeepFryer;

        [Header("Food Reference")]
        [SerializeField] private Food food;

        private void Start()
        {
            audioSourceLoop.volume = 0f;

            audioSourceLoop.pitch = audioPitch;
            audioSourceStartCooking.pitch = audioPitch;

            starCookingSound = true;
        }

        private void Update()
        {
            if (food.IsOnHeatSource())
            {
                if(food.IsBurned())
                {
                    SetAudioVolume(audioSourceLoop, 0f, 10f);
                    SetAudioVolume(audioSourceStartCooking, 0f, 10f);
                }
                else
                {
                    if (!starCookingSound)
                    {
                        audioSourceStartCooking.Stop();
                        PlayStartCookingSound(food.CurrentheatSource());
                        audioSourceStartCooking.volume = audioVolume;

                        starCookingSound = true;
                    }
                    else
                    {
                        SetAudioVolume(audioSourceStartCooking, 0f, 0.5f);
                    }

                    if (food.ItsCooking())
                    {
                        SetAudioVolume(audioSourceLoop, audioVolume, 1f);
                    }
                    else
                    {
                        SetAudioVolume(audioSourceLoop, 0f, 10f);
                        SetAudioVolume(audioSourceStartCooking, 0f, 10f);
                    }
                }
               
            }
            else
            {
                SetAudioVolume(audioSourceLoop, 0f, 10f);
                SetAudioVolume(audioSourceStartCooking, 0f, 10f);
            }

            if(food.IsOnHeatSource() == false && starCookingSound)
            {
                starCookingSound = false;
            }
        }

        private void PlayStartCookingSound(HeatSource _inHeatSource)
        {
            if (_inHeatSource.cookingSystemType == CookingSystemType.DeepFyer) //Deep fyer
            {
                if(startCookingSoundDeepFryer != null)
                {
                    audioSourceStartCooking.PlayOneShot(startCookingSoundDeepFryer);
                }

                if (loopSoundDeepFryer != null)
                {
                    audioSourceLoop.clip = loopSoundDeepFryer;
                    audioSourceLoop.Play();
                }
                else
                {
                    audioSourceLoop.Stop();
                }
            }
            else if (_inHeatSource.cookingSystemType == CookingSystemType.Oven) //Oven
            {
                if (startCookingSoundOven != null)
                {
                    audioSourceStartCooking.PlayOneShot(startCookingSoundOven);
                }

                if (loopSoundOven != null)
                {
                    audioSourceLoop.clip = loopSoundOven;
                    audioSourceLoop.Play();
                }
                else
                {
                    audioSourceLoop.Stop();
                }
            }
            else if (_inHeatSource.cookingSystemType == CookingSystemType.Stove) //Stove
            {
                if (startCookingSoundStove != null)
                {
                    audioSourceStartCooking.PlayOneShot(startCookingSoundStove);
                }

                if (loopSoundStove != null)
                {
                    audioSourceLoop.clip = loopSoundStove;
                    audioSourceLoop.Play();
                }
                else
                {
                    audioSourceLoop.Stop();
                }
            }
        }

        private void SetAudioVolume(AudioSource _audioSource, float _volume, float _speed)
        {
            if(food.CurrentheatSource() != null)
            {
                _audioSource.volume = Mathf.Lerp(_audioSource.volume, _volume, _speed * Time.deltaTime);
            }

            if(_volume == 0f)
            {
                _audioSource.volume = Mathf.Lerp(_audioSource.volume, _volume, _speed * Time.deltaTime);
            }
        }
    }
}
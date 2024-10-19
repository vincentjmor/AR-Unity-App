using System;
using UnityEngine;

namespace HeneGames.CookingSystem
{
    public class Food : MonoBehaviour
    {
        private SlicedFood slicedFood;
        private Mesh foodMesh;
        private Rigidbody rb;
        private HeatSource currentHeatSource;
        private Transform foodMeshTransform;

        private Color[] allVertexColors;
        private Vector3 startScale;

        private float cookingVertexOffsetValue = 0.001f;
        private float cookedPercentForShapeKeyAndScale;
        private float savedDrag;
        private float savedAngularDrag;

        private bool currentlyCooking;
        private bool dragValuesSaved;

        [System.Serializable]
        public struct VertexColors
        {
            [Range(0f, 1f)]
            public float r;
            [Range(0f, 1f)]
            public float g;
            [Range(0f, 1f)]
            public float b;
            [Range(0f, 1f)]
            public float a;

            public VertexColors(float _r, float _g, float _b, float _a)
            {
                r = _r;
                g = _g;
                b = _b;
                a = _a;
            }
        }

        [Header("References")]
        [SerializeField] private MeshFilter foodMeshFilter;
        [SerializeField] private SkinnedMeshRenderer foodSkinnedMeshRenderer;
        [SerializeField] private Transform foodMeshHolder;
        [SerializeField] private ParticleSystem smokeEffect;
        [SerializeField] private ParticleSystem smokeEffectNormal;
        [SerializeField] private ParticleSystem cookingEffectFat;
        [SerializeField] private ParticleSystem cookingEffectBubbles;
        [SerializeField] private ParticleSystem cookingEffectDeepFryer;

        [Header("Deep Frying Settings")]
        [SerializeField] private float floatingForce = 6.88f;
        [SerializeField] private bool floatWhenDeepFrying;
        [Range(0f, 1f)]
        [SerializeField] private float floatingDepth = 0.336f;

        [Header("Cooking Settings")]

        [Range(0, 300)]
        [SerializeField] private int fatContent = 10;

        [Range(-0.2f, 0.2f)]
        [SerializeField] private float cookedScaleMultiplier = 0.01f;

        [Header("Cooking Speed Settings")]
        [Range(0.001f, 0.2f)]
        [SerializeField] private float cookingSpeed = 0.1f;

        [Range(0.001f, 0.5f)]
        [SerializeField] private float cookedToBurnedSpeed = 0.01f;

        [Header("Cooking Percent Settings")]
        [Range(0.1f, 1f)]
        [SerializeField] private float cookedEnoughPercent = 1f;

        [Range(0.1f, 1f)]
        [SerializeField] private float burnedIfOverThisPercent = 0.45f;

        [Range(0f, 1f)]
        [SerializeField] private float stoveCookTopSidePercent = 0.1f;

        [Header("Food name")]
        public string foodName;

        [Header("Debug Variables")]
        [Range(0f, 1f)]
        [SerializeField] private float cookedPercent;
        [Range(0f, 1f)]
        [SerializeField] private float burnedPercent;
        [SerializeField] private bool foodIsReady;
        [SerializeField] private bool foodIsBurned;
        public VertexColors debugVertexColors;

        public virtual void Awake()
        {
            //Set start scale
            startScale = foodMeshHolder.localScale;

            GetMeshVertexData();

            //If food name are not set, change it to object name.
            if (foodName == "")
            {
                SetFoodName();
            }

            slicedFood = GetComponent<SlicedFood>();
            rb = GetComponent<Rigidbody>();

            //Save values
            savedDrag = rb.drag;
            savedAngularDrag = rb.angularDrag;
        }

        [Obsolete]
        public virtual void Update()
        {
            ValuesUpdate();

            if (currentlyCooking)
            {
                CookFood(currentHeatSource.cookingSystemType);
                FoodCookingScaleAndShapeKey();
                CookingEffectUpdate(foodIsBurned);

                if (foodIsBurned)
                {
                    SmokeEffect(burnedPercent);
                }
            }
            else
            {
                if (floatWhenDeepFrying && rb.useGravity == false)
                {
                    rb.useGravity = true;
                }

                SmokeEffect(0f);
                StopCookingEffects();
            }
        }

        #region Fixed update floating with oil

        protected virtual void FixedUpdate()
        {
            if (currentlyCooking && floatWhenDeepFrying)
            {
                if (currentHeatSource != null)
                {
                    if (currentHeatSource.cookingSystemType == CookingSystemType.DeepFyer)
                    {
                        if(!dragValuesSaved)
                        {
                            //Save values
                            savedDrag = rb.drag;
                            savedAngularDrag = rb.angularDrag;

                            //Set values
                            rb.angularDrag = 10f;
                            rb.drag = 6f;

                            dragValuesSaved = true;
                        }

                        Vector3 _floatingPos = new Vector3(transform.position.x, currentHeatSource.oilSurface.position.y, transform.position.z);
                        float _surfaceDistanceMultiplier = (_floatingPos.y - transform.position.y) * 100f;
                        Vector3 _force = (Vector3.up * floatingForce) * _surfaceDistanceMultiplier;

                        float _offsetX = 0.1f;
                        float _offsetZ = 0.1f;

                        if (foodSkinnedMeshRenderer == null)
                        {
                            _offsetX = foodMesh.bounds.max.x;
                            _offsetZ = foodMesh.bounds.max.z;
                        }

                        Vector3 _leftPos = transform.TransformPoint(new Vector3(_offsetX, 0f, 0f));
                        Vector3 _rightPos = transform.TransformPoint(new Vector3(-_offsetX, 0f, 0f));
                        Vector3 _upPos = transform.TransformPoint(new Vector3(0f, 0f, _offsetZ));
                        Vector3 _downPos = transform.TransformPoint(new Vector3(0f, 0f, -_offsetZ));

                        float _surfacePointYOffset = currentHeatSource.oilSurface.position.y + floatingDepth;

                        AddForceFromPoint(_leftPos, _floatingPos, _surfacePointYOffset, _force);
                        AddForceFromPoint(_rightPos, _floatingPos, _surfacePointYOffset, _force);
                        AddForceFromPoint(_upPos, _floatingPos, _surfacePointYOffset, _force);
                        AddForceFromPoint(_downPos, _floatingPos, _surfacePointYOffset, _force);
                    }
                }
            }
            else if(dragValuesSaved)
            {
                //Save values
                rb.drag = savedDrag;
                rb.angularDrag = savedAngularDrag;

                dragValuesSaved = false;
            }
        }

        private void AddForceFromPoint(Vector3 _forcePosition, Vector3 _surfacePosition, float _surfaceOffset, Vector3 _force)
        {
            if (_forcePosition.y < _surfacePosition.y)
            {
                Vector3 _surfacePoint = new Vector3(_forcePosition.x, _surfaceOffset, _forcePosition.z);
                float _leftMultiplier = Vector3.Distance(_forcePosition, _surfacePoint);
                rb.AddForceAtPosition(_force * _leftMultiplier, _forcePosition, ForceMode.Force);
            }
        }

        #endregion

        #region Core

        protected virtual void CookFood(CookingSystemType _cookingSystemType)
        {
            if (foodMesh != null)
            {
                Vector3[] _vertices = foodMesh.vertices;

                if (_cookingSystemType == CookingSystemType.Stove)
                {
                    for (int i = 0; i < _vertices.Length; i++)
                    {
                        //Get vertex world position
                        Matrix4x4 _localWorld = transform.localToWorldMatrix;
                        Vector3 _vertexWorldPosition = _localWorld.MultiplyPoint3x4(_vertices[i]);

                        if (_vertexWorldPosition.y < transform.position.y + cookingVertexOffsetValue) //Bottom vertices
                        {
                            if (allVertexColors[i].r > 0f)//Cook
                            {
                                //Cooking value
                                CookVertex(i, cookingSpeed * currentHeatSource.cookingStrenghtMultiplier);
                            }
                            else if (allVertexColors[i].b > 0f)//Burning timer
                            {
                                BurnTimerVertex(i, cookedToBurnedSpeed * currentHeatSource.cookingStrenghtMultiplier);
                            }
                            else if (allVertexColors[i].a > 0f) //Burn
                            {
                                if (_vertexWorldPosition.y != transform.position.y)
                                {
                                    BurnVertex(i, cookingSpeed * currentHeatSource.cookingStrenghtMultiplier);
                                }
                            }
                        }
                        else //Top vertices
                        {
                            if (allVertexColors[i].r > 1f - stoveCookTopSidePercent)//Cook little top
                            {
                                //Cooking value
                                CookVertex(i, cookingSpeed * currentHeatSource.cookingStrenghtMultiplier);
                            }
                        }
                    }
                }
                else if (_cookingSystemType == CookingSystemType.DeepFyer)
                {
                    //Cook
                    for (int i = 0; i < _vertices.Length; i++)
                    {
                        //Get vertex world position
                        Matrix4x4 _localWorld = transform.localToWorldMatrix;
                        Vector3 _vertexWorldPosition = _localWorld.MultiplyPoint3x4(_vertices[i]);

                        //Cook vertices below oil surface
                        if (_vertexWorldPosition.y < currentHeatSource.oilSurface.position.y)
                        {
                            //Cook
                            if (allVertexColors[i].r > 0f)
                            {
                                CookVertex(i, cookingSpeed * currentHeatSource.cookingStrenghtMultiplier);
                            }

                            //Deep fry effect
                            if (allVertexColors[i].g > 0f)
                            {
                                DeepFryVertex(i, (cookingSpeed * 2f) * currentHeatSource.cookingStrenghtMultiplier);
                            }
                        }
                    }
                }
                else
                {
                    for (int i = 0; i < _vertices.Length; i++)
                    {
                        if (allVertexColors[i].r > 0f)//Cook but don´t burn
                        {
                            //Cooking value
                            CookVertex(i, cookingSpeed * currentHeatSource.cookingStrenghtMultiplier);
                        }
                        else if (allVertexColors[i].b > 0f)//Store burning timer to blue channel
                        {
                            BurnTimerVertex(i, cookedToBurnedSpeed * currentHeatSource.cookingStrenghtMultiplier);
                        }
                        else if (allVertexColors[i].a > 0f)//Burn
                        {
                            BurnVertex(i, cookingSpeed * currentHeatSource.cookingStrenghtMultiplier);
                        }
                    }
                }

                foodMesh.colors = allVertexColors;
            }
        }

        protected virtual void CookVertex(int _index, float _cookingSpeed)
        {
            float _red = allVertexColors[_index].r;
            float _newRed = _red - _cookingSpeed * Time.deltaTime;

            allVertexColors[_index] = new Color(_newRed, allVertexColors[_index].g, allVertexColors[_index].b, allVertexColors[_index].a);
        }

        protected virtual void DeepFryVertex(int _index, float _cookingSpeed)
        {
            float _green = allVertexColors[_index].g;
            float _newGreen = _green - _cookingSpeed * Time.deltaTime;

            allVertexColors[_index] = new Color(allVertexColors[_index].r, _newGreen, allVertexColors[_index].b, allVertexColors[_index].a);
        }

        protected virtual void BurnTimerVertex(int _index, float _cookingSpeed)
        {
            float _blue = allVertexColors[_index].b;
            float _newBlue = _blue - _cookingSpeed * Time.deltaTime;

            allVertexColors[_index] = new Color(allVertexColors[_index].r, allVertexColors[_index].g, _newBlue, allVertexColors[_index].a);
        }

        protected virtual void BurnVertex(int _index, float _cookingSpeed)
        {
            float _alpha = allVertexColors[_index].a;
            float _newAlpha = _alpha - _cookingSpeed * Time.deltaTime;

            allVertexColors[_index] = new Color(allVertexColors[_index].r, allVertexColors[_index].g, allVertexColors[_index].b, _newAlpha);
        }

        [Obsolete]
        protected virtual void CookingEffectUpdate(bool _burned)
        {
            if (currentHeatSource == null)
                return;

            //Fat amount
            if (currentHeatSource.cookingSystemType == CookingSystemType.Oven)
            {
                cookingEffectFat.emissionRate = 0f;
            }
            else
            {
                cookingEffectFat.emissionRate = fatContent / 2f;
            }

            cookingEffectBubbles.emissionRate = fatContent;

            //Cooking particle effects
            if (cookingEffectFat != null)
            {
                if (!_burned)
                {
                    if (currentlyCooking)
                    {
                        if (currentHeatSource.cookingSystemType == CookingSystemType.DeepFyer)
                        {
                            if (!cookingEffectDeepFryer.isPlaying)
                            {
                                cookingEffectDeepFryer.Play();
                            }

                            cookingEffectDeepFryer.transform.position = new Vector3(CenterOfMass().x, currentHeatSource.oilSurface.position.y, CenterOfMass().z);
                            cookingEffectDeepFryer.transform.rotation = Quaternion.identity;
                        }
                        else
                        {
                            if (!cookingEffectFat.isPlaying)
                            {
                                cookingEffectFat.Play();
                            }
                        }
                    }
                    else
                    {
                        StopCookingEffects();
                    }
                }
                else
                {
                    StopCookingEffects();
                }
            }
        }

        protected virtual void StopCookingEffects()
        {
            if (cookingEffectFat.isPlaying)
            {
                cookingEffectFat.Stop();
            }

            if (cookingEffectDeepFryer.isPlaying)
            {
                cookingEffectDeepFryer.Stop();
            }
        }

        protected virtual void FoodCookingScaleAndShapeKey()
        {
            //Scale
            float _cookedPercent = cookedPercentForShapeKeyAndScale;
            float _clampedPercent = Mathf.Clamp(_cookedPercent, 0f, 1f);
            float _scalePercent = _clampedPercent * cookedScaleMultiplier;
            foodMeshHolder.localScale = startScale + (startScale * _scalePercent);

            //Set skinned mesh renderer shape key
            if (slicedFood == null)
            {
                if (foodSkinnedMeshRenderer != null)
                {
                    float _shapeKey = cookedPercentForShapeKeyAndScale * 100f;
                    float _clampedShapeKey = Mathf.Clamp(_shapeKey, 0f, 100f);

                    foodSkinnedMeshRenderer.SetBlendShapeWeight(0, _clampedShapeKey);
                }
            }
        }

        [Obsolete]
        protected virtual void SmokeEffect(float _thicness)
        {
            if (!smokeEffect.isPlaying)
            {
                smokeEffect.Play();
            }

            smokeEffect.startColor = new Color(0f, 0f, 0f, _thicness / 2f);
        }

        private void ValuesUpdate()
        {
            debugVertexColors = new VertexColors(VertexAvarageRedValue(), VertexAvarageGreenValue(), VertexAvarageBlueValue(), VertexAvarageAlphaValue());

            burnedPercent = 1f - debugVertexColors.a;

            //Cooked
            if (cookedPercent >= 1f && !foodIsBurned)
            {
                foodIsReady = true;
            }
            else
            {
                foodIsReady = false;
            }

            //Cooked percent
            cookedPercentForShapeKeyAndScale = 1f - (debugVertexColors.r / cookedEnoughPercent);
            if (!foodIsBurned)
            {
                cookedPercent = 1f - (debugVertexColors.r / cookedEnoughPercent);

                if (cookedPercent > 1f)
                {
                    cookedPercent = 1f;
                }
            }
            else
            {
                cookedPercent = 0f;
            }

            //Burned
            if (burnedPercent > burnedIfOverThisPercent)
            {
                foodIsReady = false;
                foodIsBurned = true;
            }

            //Cooking or not
            if (currentHeatSource != null)
            {
                currentlyCooking = currentHeatSource.isHeatSourceOn;
            }
            else
            {
                currentlyCooking = false;
            }
        }

        #endregion

        #region Public Methods

        public float CookedPercent()
        {
            float _percent = cookedPercent * 100f;
            return GetFormattedValue(_percent);
        }

        public float BurnedPercent()
        {
            float _percent = burnedPercent * 100f;
            return GetFormattedValue(_percent);
        }

        public bool IsReady()
        {
            return foodIsReady;
        }

        public bool IsBurned()
        {
            return foodIsBurned;
        }

        public bool IsOnHeatSource()
        {
            if (currentHeatSource != null)
            {
                return true;
            }

            return false;
        }

        public bool ItsCooking()
        {
            return currentlyCooking;
        }

        public virtual void Use()
        {
            if (SlicedFood() != null)
            {
                SlicedFood().Slice();
            }
        }

        public void AddToHeatSource(HeatSource _heatSource)
        {
            currentHeatSource = _heatSource;
        }

        public void SetCookedAndFryedPercent(float _cookedPercent, float _fryedPercent)
        {
            //Cooked percent
            Vector3[] _vertices = foodMesh.vertices;
            for (int i = 0; i < _vertices.Length; i++)
            {
                allVertexColors[i] = new Color(_cookedPercent, _fryedPercent, allVertexColors[i].b);
            }

            foodMesh.colors = allVertexColors;
        }

        public float VertexAvarageRedValue()
        {
            float _redValuesTogether = 0;

            for (int i = 0; i < allVertexColors.Length; i++)
            {
                _redValuesTogether += allVertexColors[i].r;
            }

            float _redValue = _redValuesTogether / allVertexColors.Length;

            return _redValue;
        }

        public float VertexAvarageGreenValue()
        {
            float _greenValuesTogether = 0;

            for (int i = 0; i < allVertexColors.Length; i++)
            {
                _greenValuesTogether += allVertexColors[i].g;
            }

            float _greenValue = _greenValuesTogether / allVertexColors.Length;

            return _greenValue;
        }

        public float VertexAvarageBlueValue()
        {
            float _blueValuesTogether = 0;

            for (int i = 0; i < allVertexColors.Length; i++)
            {
                _blueValuesTogether += allVertexColors[i].b;
            }

            float _blueValue = _blueValuesTogether / allVertexColors.Length;

            return _blueValue;
        }

        public float VertexAvarageAlphaValue()
        {
            float _alphaValuesTogether = 0f;

            for (int i = 0; i < allVertexColors.Length; i++)
            {
                _alphaValuesTogether += allVertexColors[i].a;
            }

            float _alphaValue = _alphaValuesTogether / allVertexColors.Length;

            return _alphaValue;
        }

        public bool IsSliceable()
        {
            if (slicedFood != null)
            {
                return slicedFood.CanSlice();
            }

            return false;
        }

        public SlicedFood SlicedFood()
        {
            return slicedFood;
        }

        public HeatSource CurrentheatSource()
        {
            return currentHeatSource;
        }

        public Vector3 CenterOfMass()
        {
            Bounds _bounds = foodMesh.bounds;
            Vector3 _localCenter = _bounds.center;
            Vector3 _worldCenter = foodMeshTransform.TransformPoint(_localCenter);

            return _worldCenter;
        }

        public void RecalculateCenterOffMass()
        {
            foodMesh.RecalculateBounds();
        }

        #endregion

        #region Private Methods

        private void GetMeshVertexData()
        {
            if (foodSkinnedMeshRenderer != null)
            {
                //Copy skinned mesh blend shapes
                int _shapeIndex = 0;
                int _frameIndex = 0;
                int _vertexCount = foodSkinnedMeshRenderer.sharedMesh.vertexCount;
                Vector3[] _deltaVertices = new Vector3[_vertexCount];
                Vector3[] _deltaNormals = new Vector3[_vertexCount];
                Vector3[] _deltaTangents = new Vector3[_vertexCount];
                foodSkinnedMeshRenderer.sharedMesh.GetBlendShapeFrameVertices(_shapeIndex, _frameIndex, _deltaVertices, _deltaNormals, _deltaTangents);

                //Set food mesh transform
                foodMeshTransform = foodSkinnedMeshRenderer.transform;

                //Create mesh snapshot
                Mesh _mesh = new Mesh();
                foodSkinnedMeshRenderer.BakeMesh(_mesh);

                //Add copied blend shape to snapshot mesh
                _mesh.AddBlendShapeFrame("Cooked", 100f, _deltaVertices, _deltaNormals, _deltaTangents);

                //Set new snapshot mesh to skinned mesh renderer mesh
                foodSkinnedMeshRenderer.sharedMesh = _mesh;

                //Save it for later use
                foodMesh = _mesh;

                //For cooking effect
                foodMeshFilter.mesh = _mesh;
            }
            else if (foodMeshFilter != null)
            {
                foodMesh = foodMeshFilter.mesh;
                foodMeshTransform = foodMeshFilter.transform;
            }

            //Setup start vertex colors, and assing it to the food mesh
            if (foodMesh != null)
            {
                Vector3[] _vertices = foodMesh.vertices;
                allVertexColors = new Color[_vertices.Length];

                for (int i = 0; i < allVertexColors.Length; i++)
                {
                    allVertexColors[i] = new Color(1f, 1f, 1f, 1f);
                }

                foodMesh.colors = allVertexColors;
            }
        }

        private bool LetterIsNumber(string _letter)
        {
            for (int i = 0; i < 9; i++)
            {
                if (_letter == i.ToString())
                {
                    return true;
                }
            }

            return false;
        }

        private float GetFormattedValue(float _value)
        {
            float _firstDecimal = _value - Mathf.Floor(_value);
            float _roundedFirstDecimal = Mathf.Round(_firstDecimal * 10f) / 10f;
            return Mathf.Floor(_value) + _roundedFirstDecimal;
        }

        private void SetFoodName()
        {
            if (foodName == "")
            {
                string _fullName = gameObject.name;

                string[] _parts = _fullName.Split(' ');

                string _withoutSpaces = _parts[0];

                if (_parts.Length > 1)
                {
                    if (!LetterIsNumber(_parts[1]))
                    {
                        _withoutSpaces = _parts[0] + " " + _parts[1];
                    }
                }

                string[] _parts2 = _withoutSpaces.Split('(');

                string _finalName = _parts2[0];

                foodName = _finalName;
            }
        }

        #endregion
    }
}
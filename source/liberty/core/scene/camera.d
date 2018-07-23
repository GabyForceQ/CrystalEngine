/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/scene/camera.d, _camera.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.scene.camera;
import liberty.core.engine : CoreEngine;
import liberty.core.scene.actor : Actor;
import liberty.core.scene.node : Node;
import liberty.core.scene.services : NodeBody;
import liberty.core.input : InputNova, Input, KeyCode, KeyModFlag, MouseButton;
import liberty.core.math.functions : radians, sin, cos;
import liberty.core.math.vector : Vector2I, Vector3F, cross;
import liberty.core.math.matrix : Matrix4F;
///
enum CameraProjection: byte {
    /// For 3D and 2D views
    Perspective = 0x00,
    /// Only for 2D views
    Orthographic = 0x01
}
///
enum CameraMovement: byte {
	///
	Forward = 0x00,
	///
	Backward = 0x01,
	///
	Left = 0x02,
	///
	Right = 0x03
}
///
final class Camera : Actor {
	mixin(NodeBody);
	private {
		Matrix4F _projection;
        Matrix4F _view;
		// Attributes.
		Vector3F _position;
		Vector3F _front;
		Vector3F _up;
		Vector3F _right;
		Vector3F _worldUp;
		// Euler Angles.
		float _yaw;
		float _pitch;
		// Options.
		float _movementSpeedMultiplier = 100.0f;
		float _movementSpeed = 8.0f;
		float _mouseSensitivity = 0.1f;
		float _fov = 45.0f;
		bool _constrainPitch = true;
		bool _firstMouse = true;
		bool _scrollReversedOrder = true; // TODO: For Speed Multiplier.
		float _lastX;
		float _lastY;
		float _nearPlane = 0.1f;
		float _farPlane = 1000.0f;
		CameraProjection _cameraProjection = CameraProjection.Perspective;
	}
	///
	enum Yaw = -90.0f;
	///
	enum Pitch = 0.0f;
	///
	float fov() pure nothrow const {
		return _fov;
	}
	///
	float nearPlane() pure nothrow const {
		return _nearPlane;
	}
	///
	float farPlane() pure nothrow const {
		return _farPlane;
	}
	///
	private static immutable constructor = q{
		_front = Vector3F.backward;
        _position = Vector3F.zero;
        _worldUp = Vector3F.up;
        _yaw = Yaw;
        _pitch = Pitch;
        updateCameraVectors();
        _lastX = CoreEngine.get.mainWindow.width / 2;
        _lastY = CoreEngine.get.mainWindow.height / 2;
	};
	///
	this(string id, Node parent, Vector3F position = Vector3F.zero, Vector3F up = Vector3F.up, float yaw = Yaw, float pitch = Pitch) {
		super(id, parent);
	}
	/// Sets the camera world position using x, y and z coordinates.
	void position(float x, float y, float z) pure nothrow @safe @nogc {
		_position = Vector3F(x, y, z);
	}
	/// Sets the camera world position using a vector for coordinates.
	void position(Vector3F position) pure nothrow @safe @nogc {
		_position = position;
	}
	/// Gets the camera position in the world.
	ref const(Vector3F) position() pure nothrow @safe @nogc {
		return _position;
	}
	///
	Matrix4F projectionMatrix() {
		Vector2I size = CoreEngine.get.mainWindow.size;
		final switch (_cameraProjection) with (CameraProjection) {
			case Perspective:
				return Matrix4F.perspective(radians(_fov), cast(float)size.x / size.y, _nearPlane, _farPlane);
			case Orthographic:
				return Matrix4F.orthographic(0, size.x, size.y, 0, _nearPlane, _farPlane);
		}
	}
	///
	Matrix4F viewMatrix() {
		return Matrix4F.lookAt(_position, _position + _front, _up);
	}
	///
	void fov(float value) {
		_fov = value;
	}
	///
	void resetFov() {
		_fov = 45.0f;
	}
	///
	override void update(in float deltaTime) {
		if (scene.activeCamera.id == id) {
			float velocity = _movementSpeed * deltaTime;
			// Process Mouse Scroll.
			if (Input.get.isMouseScrolling()) {
				if (Input.get.isKeyHold(KeyModFlag.LeftCtrl)) {
					if(_fov >= 1.0f && _fov <= 45.0f) {
						if (_scrollReversedOrder) {
							_fov += Input.get.mouseDeltaWheelY();
						} else {
							_fov -= Input.get.mouseDeltaWheelY();
						}
					}
					if(_fov <= 1.0f) {
						_fov = 1.0f;
					}
					if(_fov >= 45.0f) {
						_fov = 45.0f;
					}
				} else {
					velocity *= _movementSpeedMultiplier;
				}
			}
			// Process Keyboard.
			if (InputNova.get.isKeyHold(KeyCode.W)) {
				_position += _front * velocity;
			}
			if (InputNova.get.isKeyHold(KeyCode.S)) {
				_position -= _front * velocity;
			}
			if (InputNova.get.isKeyHold(KeyCode.A)) {
				_position -= _right * velocity;
			}
			if (InputNova.get.isKeyHold(KeyCode.D)) {
				_position += _right * velocity;
			}
			// Process Mouse Movement.
			if (Input.get.isMouseButtonPressed(MouseButton.Right)) {
				Input.get.windowGrab = true;
				Input.get.cursorVisible = false;
				if (Input.get.isMouseMoving()) {
					if (_firstMouse) {
						_lastX = Input.get.mousePosition.x;
						_lastY = Input.get.mousePosition.y;
						_firstMouse = false;
					}
					float xoffset = Input.get.mousePosition.x - _lastX;
					float yoffset = _lastY - Input.get.mousePosition.y;
					_lastX = Input.get.mousePosition.x;
					_lastY = Input.get.mousePosition.y;
					xoffset *= _mouseSensitivity;
					yoffset *= _mouseSensitivity;
					_yaw   += xoffset;
					_pitch += yoffset;
					if (_constrainPitch) {
						if (_pitch > 89.0f) {
							_pitch =  89.0f;
						}
						if (_pitch < -89.0f) {
							_pitch = -89.0f;
						}
					}
					updateCameraVectors();
				}
			} else {
				Input.get.windowGrab = false;
				Input.get.cursorVisible = true;
				_firstMouse = true;
			}
			_projection = projectionMatrix;
			_view = viewMatrix;
		}
	}
	///
	ref const(Matrix4F) projection() {
		return _projection;
	}
	///
	ref const(Matrix4F) view() {
		return _view;
	}
	///
	void rotateYaw(float value) {
		_yaw += value;
	}
	///
    void rotatePitch(float value) {
        _pitch += value;
    }
    ///
    void yaw(float value) {
        _yaw = value;
    }
    ///
    void pitch(float value) {
        _pitch = value;
    }
	///
	void switchProjectionType() {
		final switch (_cameraProjection) with (CameraProjection) {
			case Perspective:
				_cameraProjection = Orthographic;
				break;
			case Orthographic:
				_cameraProjection = Perspective;
				break;
		}
	}
	private void updateCameraVectors() {
		Vector3F front;
		front.x = cos(radians(_yaw)) * cos(radians(_pitch));
        front.y = sin(radians(_pitch));
        front.z = sin(radians(_yaw)) * cos(radians(_pitch));
        _front = front.normalized();
        _right = _front.cross(_worldUp);
        _right.normalize();
        _up = _right.cross(_front);
        _up.normalize();
	}
}
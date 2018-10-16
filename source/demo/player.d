/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/demo/player.d)
 * Documentation:
 * Coverage:
**/
module demo.player;

import liberty.engine;

/**
 * Example class for player.
**/
final class Player : Actor {
  mixin(NodeBody);

  private {
    BSPPyramid playerBody;
    float gravity = -80.0f;
    float jumpPower = 20.0f;
    float upSpeed = 0;

    UISquare square;

    int killZ = -10;

    Material pyramidMaterial;
    Material squareMaterial;
  }

  /**
   * Optional.
   * If declared, it is called after all objects instantiation.
  **/
  override void start() {
    pyramidMaterial = new Material("res/textures/mud.bmp");
    squareMaterial = new Material("res/textures/default2.bmp");

    (square = spawn!UISquare("UISquare"))
      .build(squareMaterial);
    
    (playerBody = spawn!BSPPyramid("Body"))
      .build()
      .getTransform()
      .translate(0.0f, 10.0f, 0.0f);

    getScene().getActiveCamera().setMovementSpeed(10.0f).lockMouseMove().setPitch(-90.0f);
  }

  /**
   * Optional.
   * If declared, it is called every frame.
  **/
  override void update() {
    const float deltaTime = Time.getDelta();
    const float cameraSpeed = getScene().getActiveCamera().getMovementSpeed();

    if (Input.isKeyHold(KeyCode.LEFT))
      playerBody.getTransform().translateX(-cameraSpeed * deltaTime);

    if (Input.isKeyHold(KeyCode.RIGHT))
      playerBody.getTransform().translateX(cameraSpeed * deltaTime);
    
    if (Input.isKeyHold(KeyCode.UP))
      playerBody.getTransform().translateZ(-cameraSpeed * deltaTime);

    if (Input.isKeyHold(KeyCode.DOWN))
      playerBody.getTransform().translateZ(cameraSpeed * deltaTime);

    if (Input.isKeyDown(KeyCode.SPACE))
      jump();

    upSpeed += gravity * deltaTime;
    playerBody.getTransform().translateY(upSpeed * deltaTime);
    
    const float terrainHeight = getScene().getTree().getChild!Terrain("DemoTerrain")
      .getHeight(playerBody.getTransform().getWorldPosition().x, playerBody.getTransform().getWorldPosition().z) + 0.5f;
    
    if (playerBody.getTransform().getWorldPosition().y < terrainHeight) {
      upSpeed = 0;
      playerBody.getTransform().translateY(-playerBody.getTransform().getWorldPosition().y + terrainHeight);
    }

    if (Input.isKeyDown(KeyCode.B))
      spawn!BSPCube("cc");

    if (Input.isKeyDown(KeyCode.T))
      GfxEngine.toggleWireframe();

    if (playerBody.getTransform().getWorldPosition().y < killZ)
      CoreEngine.pause();

    if (Input.isKeyDown(KeyCode.ENTER))
      playerBody.getRenderer().getModel().toggleMaterials([Material.getDefault()], [pyramidMaterial]);

    Vector3F terrainPoint = Input.getMousePicker().getCurrentTerrainPoint();

    static int oo = 0;
    if (oo == 200) {
      Logger.exception(terrainPoint.toString());
      oo = 0;
    }
    oo++;

    if (Input.isMouseButtonDown(MouseButton.LEFT))
      playerBody.getTransform().translate(-playerBody.getTransform().getWorldPosition() + terrainPoint);
  }

  private void jump() {
    upSpeed = jumpPower;
  }
}
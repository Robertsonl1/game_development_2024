mod movement;
mod debug;
mod spaceship;
mod camera;
mod asteroids;
mod assetloader;
mod collision_detection;
mod despawn;

use bevy::prelude::*;
use debug::DebugPlugin;
use movement::MovementPlugin;
use spaceship::SpaceshipPlugin;
use camera::CameraPlugin;
use assetloader::AssetLoaderPlugin;
use asteroids::AsteroidPlugin;
use collision_detection::CollisionDetectionPlugin;
use despawn::DespawnPlugin;

fn main() {
    App::new()
        // Bevy built-ins
        .insert_resource(ClearColor(Color::rgb(0.0, 0.0, 0.0)))
        .insert_resource(AmbientLight {
            color: Color::default(),
            brightness: 0.75,
        })



        .add_plugins(SpaceshipPlugin)
        // User configured plugins.
        .add_plugins(AssetLoaderPlugin)
        .add_plugins(CameraPlugin)
        .add_plugins(MovementPlugin)
        .add_plugins(DebugPlugin)
        .add_plugins(DefaultPlugins)
        .add_plugins(AsteroidPlugin)
        .add_plugins(CollisionDetectionPlugin)
        .add_plugins(DespawnPlugin)
        .run();
}

mod movement;
mod debug;
mod spaceship;
mod camera;

use bevy::prelude::*;
use debug::DebugPlugin;
use movement::MovementPlugin;
use spaceship::SpaceshipPlugin;
use camera::CameraPlugin;

fn main() {
    App::new()
        // Bevy built-ins
        .insert_resource(ClearColor(Color::rgb(0.7, 0.4, 0.0)))
        .insert_resource(AmbientLight {
            color: Color::default(),
            brightness: 0.75,
        })



        .add_plugins(SpaceshipPlugin)
        // User configured plugins.
        .add_plugins(CameraPlugin)
        .add_plugins(MovementPlugin)
        .add_plugins(DebugPlugin)
        .add_plugins(DefaultPlugins)
        .run();
}

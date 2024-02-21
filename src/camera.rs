use bevy::core_pipeline::bloom::{BloomCompositeMode, BloomSettings};
use bevy::core_pipeline::tonemapping::Tonemapping;
use bevy::prelude::*;

const CAMERA_DISTANCE: f32 = 80.0;

pub struct CameraPlugin;

impl Plugin for CameraPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Startup, spawn_camera);
    }
}

fn spawn_camera(mut commands: Commands) {
    commands.spawn((Camera3dBundle {
        transform: Transform::from_xyz(0.0, CAMERA_DISTANCE, 0.0).looking_at(Vec3::ZERO, Vec3::Z),
        tonemapping: Tonemapping::BlenderFilmic,
        camera: Camera {hdr: true, ..default()},
        ..default()
    }, BloomSettings {
        composite_mode: BloomCompositeMode::Additive,
        intensity: 0.05,
        ..default()
    }));
}
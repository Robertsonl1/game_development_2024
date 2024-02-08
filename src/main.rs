use std::fmt::{Display, Formatter};

fn main() {
    let ranga: u8 = 129;
    let mut player: Player = Player{ name: "Joe".to_string(), health: 0 };
    player.take_damage();
    let player_2 = Player::new("Bob".to_string());

    println!("Value is {player}");
}
#[derive(Debug)]
struct Player{
    name: String,
    health: i8,

}
impl Display for Player{
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} {}", self.name, self.health)
    }
}
impl Player{
    fn new(name: String) -> Player{
        return Player{ name: name, health: 5 }
    }
    fn take_damage(&mut self) {
        self.health -= 1;


    }

}
module dos_static_pfp::static_pfp;

use std::string::String;
use sui::vec_map::{Self, VecMap};

public struct StaticPfp<phantom T: key + store> has key, store {
    id: UID,
    name: String,
    number: u64,
    description: String,
    image_uri: String,
    attributes: VecMap<String, String>,
}

const EAttributesAlreadyRevealed: u64 = 0;
const EImageAlreadyRevealed: u64 = 1;

public fun new<T: key + store>(
    name: String,
    number: u64,
    description: String,
    ctx: &mut TxContext,
): StaticPfp<T> {
    StaticPfp {
        id: object::new(ctx),
        name: name,
        number: number,
        description: description,
        image_uri: b"".to_string(),
        attributes: vec_map::empty(),
    }
}

public fun new_revealed<T: key + store>(
    name: String,
    number: u64,
    description: String,
    image_uri: String,
    attribute_keys: vector<String>,
    attribute_values: vector<String>,
    ctx: &mut TxContext,
): StaticPfp<T> {
    StaticPfp {
        id: object::new(ctx),
        name: name,
        number: number,
        description: description,
        image_uri: image_uri,
        attributes: vec_map::from_keys_values(attribute_keys, attribute_values),
    }
}

public fun reveal_attributes<T: key + store>(
    self: &mut StaticPfp<T>,
    attribute_keys: vector<String>,
    attribute_values: vector<String>,
) {
    assert!(self.attributes.is_empty(), EAttributesAlreadyRevealed);
    self.attributes = vec_map::from_keys_values(attribute_keys, attribute_values);
}

public fun reveal_image<T: key + store>(self: &mut StaticPfp<T>, image_uri: String) {
    assert!(self.image_uri.is_empty(), EImageAlreadyRevealed);
    self.image_uri = image_uri;
}

public fun name<T: key + store>(self: &StaticPfp<T>): String {
    self.name
}

public fun number<T: key + store>(self: &StaticPfp<T>): u64 {
    self.number
}

public fun description<T: key + store>(self: &StaticPfp<T>): String {
    self.description
}

public fun image_uri<T: key + store>(self: &StaticPfp<T>): String {
    self.image_uri
}

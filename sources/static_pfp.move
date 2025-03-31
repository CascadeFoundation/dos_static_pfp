module dos_static_pfp::static_pfp;

use std::string::String;
use sui::vec_map::{Self, VecMap};

public struct StaticPfp has store {
    number: u64,
    name: String,
    description: String,
    external_url: String,
    image_uri: String,
    attributes: VecMap<String, String>,
}

const EAttributesAlreadyRevealed: u64 = 0;
const EAttributesLengthMismatch: u64 = 1;
const EInvalidAttributeKeyLength: u64 = 2;

// Create a new static PFP.
//
// The `image_uri` is specified upfront because it can be calculated ahead of time
// without revealing the image. For example, if you're using Walrus for image storage,
// you can use the Walrus CLI to pre-calculate blob IDs to use as image URIs.
// The actual image can be uploaded at a later time.
public fun new(
    name: String,
    number: u64,
    description: String,
    external_url: String,
    image_uri: String,
): StaticPfp {
    StaticPfp {
        number: number,
        name: name,
        description: description,
        external_url: external_url,
        image_uri: image_uri,
        attributes: vec_map::empty(),
    }
}

public fun destroy(self: StaticPfp) {
    let StaticPfp {
        ..,
    } = self;
}

public fun reveal(
    self: &mut StaticPfp,
    attribute_keys: vector<String>,
    attribute_values: vector<String>,
) {
    assert!(self.attributes.is_empty(), EAttributesAlreadyRevealed);
    assert!(attribute_keys.length() == attribute_values.length(), EAttributesLengthMismatch);

    // Assert none of the attribute keys are blank.
    attribute_keys.do!(|v| assert!(v.length() > 0, EInvalidAttributeKeyLength));

    self.attributes = vec_map::from_keys_values(attribute_keys, attribute_values);
}

public fun name(self: &StaticPfp): String {
    self.name
}

public fun number(self: &StaticPfp): u64 {
    self.number
}

public fun description(self: &StaticPfp): String {
    self.description
}

public fun image_uri(self: &StaticPfp): String {
    self.image_uri
}

public fun attributes(self: &StaticPfp): VecMap<String, String> {
    self.attributes
}

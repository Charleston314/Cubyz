#version 430

layout (local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

struct AnimationData {
	int frames;
	int time;
};

struct TextureData {
	int textureIndices[6];
	uint absorption;
	float reflectivity;
	float fogDensity;
	uint fogColor;
};

layout(std430, binding = 0) buffer _animation
{
	AnimationData animation[];
};
layout(std430, binding = 6) buffer _textureDataIn
{
	TextureData textureDataIn[];
};
layout(std430, binding = 1) buffer _textureDataOut
{
	TextureData textureDataOut[];
};

uniform int time;
uniform int size;

void main() {
	uint index = gl_GlobalInvocationID.x;
    if(index >= size) return;
	for(int i = 0; i < 6; i++) {
        int textureIndex = textureDataIn[index].textureIndices[i];
        textureIndex = textureIndex + time / animation[textureIndex].time % animation[textureIndex].frames;
		textureDataOut[index].textureIndices[i] = textureIndex;
	}
}
extends Area2D

enum Directions{
	U,D,R,L,
	UL,UR,DR,DL,
	NEUTRAL
}

export (Directions) var dir = Directions.R

import { IsOptional, IsString, MinLength, MaxLength, Matches, IsInt } from 'class-validator';

export class UpdateUserDto {
    @IsOptional()
    @IsString()
    @MinLength(3, { message: 'Username must be at least 3 characters long' })
    @MaxLength(20, { message: 'Username must not exceed 20 characters' })
    @Matches(/^[a-zA-Z0-9_]+$/, {
        message: 'Username can only contain letters, numbers, and underscores',
    })
    username?: string;

    @IsOptional()
    @IsInt({ message: 'Avatar must be an integer' })
    avatar?: number;
}


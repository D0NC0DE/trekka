import { Controller, Get, Param, Delete, Patch, Body, NotFoundException } from '@nestjs/common';
import { UsersService } from './users.service';
import { GetUser } from './decorator';
import { UpdateUserDto } from './dto';
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  async getCurrentUser(@GetUser('userId') userId: string) {
    const user = await this.usersService.findByIdWithWallet(userId);
    
    if (!user) {
      throw new NotFoundException('User not found');
    }
    
    return user;
  }

  @Get(':id')
  async getUserById(@Param('id') id: string) {
    const user = await this.usersService.findById(id);
    
    if (!user) {
      throw new NotFoundException('User not found');
    }
    
    return user;
  }

  @Patch('me')
  async updateUser(
    @GetUser('userId') userId: string,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return this.usersService.updateUser(userId, updateUserDto);
  }

  @Delete('me')
  async deleteAccount(@GetUser('userId') userId: string) {
    return this.usersService.softDelete(userId);
  }
}

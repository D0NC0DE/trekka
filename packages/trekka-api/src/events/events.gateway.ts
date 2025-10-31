import {
    WebSocketGateway,
    SubscribeMessage,
    MessageBody,
    ConnectedSocket,
    OnGatewayConnection,
    OnGatewayDisconnect,
    WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { UseGuards } from '@nestjs/common';
import { WsAuthGuard } from './guards/ws-auth.guard';
import { GetWsUser } from './decorators/get-ws-user.decorator';

@WebSocketGateway()
export class EventsGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer()
    server: Server;

    handleConnection(client: Socket) {
        console.log(`Client connected: ${client.id}`);
    }

    handleDisconnect(client: Socket) {
        console.log(`Client disconnected: ${client.id}`);
    }

    @UseGuards(WsAuthGuard)
    @SubscribeMessage('message')
    handleMessage(
        @MessageBody() payload: any,
        @ConnectedSocket() client: Socket,
        @GetWsUser() user: any,
    ) {
        console.log('Message received:', payload);
        console.log('From user:', user);

        return {
            event: 'message',
            data: {
                hello: 'Hello from server!',
                payload: payload,
                user: {
                    userId: user.userId,
                    email: user.email,
                },
            },
        };
    }
}


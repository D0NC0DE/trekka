import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as postmark from 'postmark';
import { otpTemplate, welcomeTemplate, WelcomeEmailData } from './templates';
import { OtpEmailData } from './types';

@Injectable()
export class EmailService {
    private readonly client: postmark.ServerClient;
    private readonly fromEmail = 'security@trekkaweb.com';

    constructor(private configService: ConfigService) {
        const mailSenderKey = this.configService.get<string>('MAIL_SENDER_KEY')!;
        if (!mailSenderKey) {
            throw new Error('MAIL_SENDER_KEY is not set');
        }
        this.client = new postmark.ServerClient(mailSenderKey);
    }

    private async sendEmail(
        to: string,
        subject: string,
        htmlBody: string,
        textBody: string,
        tag: string
    ): Promise<void> {
        await this.client.sendEmail({
            From: this.fromEmail,
            To: to,
            Subject: subject,
            Tag: tag,
            HtmlBody: htmlBody,
            TextBody: textBody,
            MessageStream: 'outbound'
        });
    }
    
    async sendOTPEmail(email: string, data: OtpEmailData): Promise<void> {
        const template = otpTemplate(data);
        await this.sendEmail(
            email,
            template.subject,
            template.htmlBody,
            template.textBody,
            'otp-verification'
        );
    }

    async sendWelcomeEmail(email: string, data: WelcomeEmailData): Promise<void> {
        const template = welcomeTemplate(data);
        await this.sendEmail(
            email,
            template.subject,
            template.htmlBody,
            template.textBody,
            'welcome'
        );
    }
}
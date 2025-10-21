import { EmailTemplate, OtpEmailData } from '../types';
import { OtpPurpose } from 'src/generated/prisma/client';

const getPurposeText = (purpose: OtpPurpose): string => {
    const purposeMap = {
        [OtpPurpose.AUTH]: 'Authentication',
        [OtpPurpose.WITHDRAW]: 'Withdrawal Confirmation',
        [OtpPurpose.EXPORT_KEY]: 'Wallet Key Export',
    };
    return purposeMap[purpose] || 'Verification';
};

const getPurposeEmoji = (purpose: OtpPurpose): string => {
    const emojiMap = {
        [OtpPurpose.AUTH]: '🔐',
        [OtpPurpose.WITHDRAW]: '💰',
        [OtpPurpose.EXPORT_KEY]: '🔑',
    };
    return emojiMap[purpose] || '✅';
};

export const otpTemplate = (data: OtpEmailData): EmailTemplate => {
    const purposeText = getPurposeText(data.purpose);
    const emoji = getPurposeEmoji(data.purpose);

    return {
        subject: `${emoji} Your Trekka ${purposeText} Code`,

        htmlBody: `
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Trekka Verification Code</title>
          <style>
            body {
              margin: 0;
              padding: 0;
              background-color: #f5f5f5;
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
              color: #333333;
            }
            
            .container {
              max-width: 500px;
              margin: 40px auto;
              background: #ffffff;
              border-radius: 8px;
              overflow: hidden;
              box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            
            .header {
              text-align: center;
              padding: 24px 20px;
              background: #ffffff;
              border-bottom: 2px solid #00A896;
            }
            
            .header h1 {
              margin: 0;
              font-size: 20px;
              font-weight: 600;
              color: #00A896;
              letter-spacing: 1px;
            }
            
            .content {
              padding: 32px 24px;
            }
            
            .greeting {
              font-size: 15px;
              color: #666666;
              margin-bottom: 16px;
            }
            
            .username {
              color: #00A896;
              font-weight: 600;
            }
            
            .message {
              color: #333333;
              font-size: 14px;
              line-height: 1.6;
              margin-bottom: 24px;
            }
            
            .otp-container {
              background: #f8f9fa;
              border: 1px solid #e0e0e0;
              border-radius: 6px;
              padding: 20px;
              text-align: center;
              margin: 24px 0;
            }
            
            .otp-label {
              font-size: 11px;
              color: #666666;
              text-transform: uppercase;
              letter-spacing: 1px;
              margin-bottom: 8px;
            }
            
            .otp-code {
              font-family: 'Courier New', monospace;
              font-size: 32px;
              font-weight: 700;
              color: #00A896;
              letter-spacing: 8px;
              margin: 8px 0;
              user-select: all;
            }
            
            .expiry-notice {
              background: #fff3e0;
              border-left: 3px solid #ff9800;
              padding: 12px 16px;
              margin: 20px 0;
              font-size: 13px;
              color: #663c00;
            }
            
            .expiry-notice strong {
              display: block;
              margin-bottom: 4px;
            }
            
            .warning {
              color: #666666;
              font-size: 12px;
              margin-top: 20px;
              padding: 12px;
              background: #f5f5f5;
              border-radius: 4px;
            }
            
            .footer {
              background: #fafafa;
              padding: 20px;
              text-align: center;
              border-top: 1px solid #e0e0e0;
            }
            
            .footer p {
              margin: 4px 0;
              font-size: 11px;
              color: #999999;
            }
            
            @media only screen and (max-width: 600px) {
              .container {
                margin: 20px;
              }
              
              .otp-code {
                font-size: 28px;
                letter-spacing: 6px;
              }
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>TREKKA</h1>
            </div>
            
            <div class="content">
              <div class="greeting">
                Hello <span class="username">${data.username}</span>,
              </div>
              
              <div class="message">
                Your verification code for ${purposeText} is ready. Enter this code to continue.
              </div>
              
              <div class="otp-container">
                <div class="otp-label">Verification Code</div>
                <div class="otp-code">${data.otp}</div>
              </div>
              
              <div class="expiry-notice">
                <strong>Expires in ${data.expiresInMinutes} minutes</strong>
                Please use this code before it expires.
              </div>
              
              <div class="warning">
                If you didn't request this code, you can safely ignore this email.
              </div>
            </div>
            
            <div class="footer">
              <p>© ${new Date().getFullYear()} Trekka. All rights reserved.</p>
              <p>This is an automated message, please do not reply.</p>
            </div>
          </div>
        </body>
      </html>
    `,

        textBody: `
TREKKA - ${purposeText.toUpperCase()}

Hello ${data.username},

Your verification code for ${purposeText} is:

${data.otp}

⏱️ This code will expire in ${data.expiresInMinutes} minutes.

IMPORTANT:
- Enter this code to complete your ${purposeText.toLowerCase()}
- Do not share this code with anyone
- If you didn't request this code, please ignore this email

---
© ${new Date().getFullYear()} Trekka. All rights reserved.
This is an automated message, please do not reply.
Secure. Fast. Decentralized.
    `.trim(),
    };
};


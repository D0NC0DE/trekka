import { EmailTemplate } from '../types';

export type WelcomeEmailData = {
  username: string;
  isNewUser: boolean;
};

export const welcomeTemplate = (data: WelcomeEmailData): EmailTemplate => {
  const greeting = data.isNewUser ? 'Welcome to Trekka!' : 'Welcome back!';
  const message = data.isNewUser 
    ? 'Your account has been successfully created and verified.'
    : 'You have successfully signed in to your account.';

  return {
    subject: greeting,

    htmlBody: `
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>${greeting}</title>
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
            
            .info-box {
              background: #f8f9fa;
              border-left: 4px solid #00A896;
              padding: 16px;
              margin: 24px 0;
              border-radius: 4px;
            }
            
            .info-box p {
              margin: 8px 0;
              font-size: 14px;
              color: #555555;
              line-height: 1.6;
            }
            
            .info-box ul {
              margin: 8px 0;
              padding-left: 20px;
            }
            
            .info-box li {
              font-size: 14px;
              color: #555555;
              line-height: 1.6;
              margin: 4px 0;
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
                ${message}
              </div>
              
              ${data.isNewUser ? `
              <div class="info-box">
                <p><strong>Welcome to the Playground</strong></p>
                <p>You've just joined Africa's gamified peer-to-peer economy. Here's what you can do:</p>
                <ul>
                  <li>Connect and transact directly with your community</li>
                  <li>Experience blockchain-powered simplicity</li>
                  <li>Join a movement bringing true P2P back to African life</li>
                </ul>
              </div>
              ` : `
              <div class="info-box">
                <p><strong>Security Reminder</strong></p>
                <p>If this wasn't you, please secure your account immediately.</p>
              </div>
              `}
              
              <p style="margin-top: 24px; font-size: 13px; color: #666666; line-height: 1.6;">
                Bringing true peer-to-peer back to African life — powered by blockchain, guided by simplicity, driven by community.
              </p>
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
${greeting}

Hi ${data.username}!

${message}

${data.isNewUser ? `
Welcome to the Playground:
You've just joined Africa's gamified peer-to-peer economy. Here's what you can do:
- Connect and transact directly with your community
- Experience blockchain-powered simplicity
- Join a movement bringing true P2P back to African life
` : `
Security Reminder:
If this wasn't you, please secure your account immediately.
`}

Bringing true peer-to-peer back to African life — powered by blockchain, guided by simplicity, driven by community.

© ${new Date().getFullYear()} Trekka. All rights reserved.
This is an automated message, please do not reply.
    `.trim(),
  };
};


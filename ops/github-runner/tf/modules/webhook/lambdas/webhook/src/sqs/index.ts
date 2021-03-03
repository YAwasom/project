import { SQS } from 'aws-sdk';
import AWS from 'aws-sdk';
import AWSXRay from 'aws-xray-sdk-core';

AWSXRay.captureAWS(AWS);

AWS.config.update({
  region: process.env.AWS_REGION,
});

const sqs = new SQS();

export interface ActionRequestMessage {
  id: number;
  eventType: string;
  repositoryName: string;
  repositoryOwner: string;
  installationId: number;
}

export const sendActionRequest = async (message: ActionRequestMessage) => {
  await sqs
    .sendMessage({
      QueueUrl: String(process.env.SQS_URL_WEBHOOK),
      MessageBody: JSON.stringify(message),
      MessageGroupId: String(message.id),
    })
    .promise();
};

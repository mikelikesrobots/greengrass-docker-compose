import os
import sys
import traceback

from awsiot.greengrasscoreipc.clientv2 import GreengrassCoreIPCClientV2
from localpubsub import publisher, subscriber


def main():
    topic = os.environ.get("MQTT_TOPIC", "example/topic")
    message = os.environ.get("MQTT_MESSAGE", "Example Hello!")

    print(f"Using topic '{topic}'")
    print(f"Using message '{message}'")

    try:
        ipc_client = GreengrassCoreIPCClientV2()
        # Subscribe to the topic before publishing
        subscriber.subscribe_to_topic(ipc_client, topic)
        # Publish a message for N times and exit
        publisher.publish_message_N_times(ipc_client, topic, message, 1000)
    except Exception:
        print("Exception occurred", file=sys.stderr)
        traceback.print_exc()
        exit(1)


if __name__ == "__main__":
    main()

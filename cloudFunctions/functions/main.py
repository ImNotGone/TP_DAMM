import firebase_admin
from firebase_admin import firestore, messaging
from firebase_functions import firestore_fn

# Initialize the Firebase Admin SDK
firebase_admin.initialize_app()


@firestore_fn.on_document_updated(
    document="volunteerings/{volunteering_id}"
)
def on_applicants_updated(event: firestore_fn.Event[firestore_fn.Change]):
    """
    Cloud Function triggered when 'volunteerings/{volunteering_id}' document is updated.
    Sends notifications to users whose application status changes to 'accepted' or 'rejected
    in the 'applicants' field of the volunteering'.
    """

    volunteering_id = event.params['volunteering_id']

    before_snapshot = event.data.before
    after_snapshot = event.data.after

    if not before_snapshot or not after_snapshot:
        print("Before or after snapshot is missing.")
        return

    old_data = before_snapshot.to_dict()
    new_data = after_snapshot.to_dict()

    if not old_data or not new_data:
        print("Old or new document data is missing.")
        return

    old_applicants = old_data.get('applicants', {})
    new_applicants = new_data.get('applicants', {})

    volunteering_title = new_data.get("title", "Volunteering Opportunity")

    # Check for status changes
    for user_id, new_status in new_applicants.items():
        old_status = old_applicants.get(user_id, None)

        # Handle acceptance
        if new_status is True and old_status != new_status:
            print(f"User {user_id} has been accepted. Sending acceptance notification...")
            send_notification(
                user_id,
                "Application Accepted!",
                f"Congratulations! You've been accepted for '{volunteering_title}'.",
                f"/volunteering/{volunteering_id}"
            )

        # Handle rejection
        elif new_status is False and old_status != new_status:
            print(f"User {user_id} has been rejected. Sending rejection notification...")
            send_notification(
                user_id,
                "Application Rejected",
                f"Unfortunately, you were not selected for '{volunteering_title}'.",
                f"/volunteering/{volunteering_id}"
            )


def send_notification(user_id: str, title: str, body: str, deep_link: str):
    db = firestore.client()

    # Retrieve the user's FCM token
    user_doc = db.collection('users').document(user_id).get()
    if not user_doc.exists:
        print(f"User document {user_id} does not exist.")
        return

    user_data = user_doc.to_dict()
    fcm_token = user_data.get('fcmToken')

    if not fcm_token:
        print(f"No FCM token found for user {user_id}.")
        return

    # Create and send the notification
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        data={
            "deepLink": deep_link
        },
        token=fcm_token,
    )

    try:
        response = messaging.send(message)
        print(f"Notification sent to {user_id} with response: {response}")
    except Exception as e:
        print(f"Error sending notification to {user_id}: {e}")



@firestore_fn.on_document_created(
    document="news/{news_id}"
)
def on_news_created(event: firestore_fn.Event[firestore_fn.DocumentSnapshot]):
    """
    Cloud Function triggered when a new news document is created.
    Sends a notification to all users informing them about the news with a deep link.
    """

    news_snapshot = event.data
    if not news_snapshot:
        print("No news data available.")
        return

    news_data = news_snapshot.to_dict()
    if not news_data:
        print("News document data is missing.")
        return

    news_title = news_data.get("title", "New News Article")
    news_id = news_snapshot.id

    deep_link = f"/newsDetail/{news_id}"

    send_news_notification(news_title, deep_link)


def send_news_notification(news_title: str, deep_link: str):
    """
    Sends a notification to all users informing them of a new news article.
    """

    db = firestore.client()

    users_ref = db.collection("users")
    users = users_ref.stream()

    for user_doc in users:
        user_data = user_doc.to_dict()
        fcm_token = user_data.get("fcmToken")

        if not fcm_token:
            print(f"No FCM token found for user {user_doc.id}. Skipping.")
            continue

        message = messaging.Message(
            notification=messaging.Notification(
                title="New News Added!",
                body=f"Check out the latest news: {news_title}",
            ),
            token=fcm_token,
            data={
                "deepLink": deep_link
            },
        )

        try:
            response = messaging.send(message)
            print(f"Notification sent to user {user_doc.id} with response: {response}")
        except Exception as e:
            print(f"Error sending notification to user {user_doc.id}: {e}")

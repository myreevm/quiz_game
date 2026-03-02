# Question Images

This project supports optional images per question via the `imageAsset` field.

## JSON format

```json
{
  "question": "Who was the first president of the United States?",
  "imageAsset": "assets/question_images/usa/famous_people/george_washington.jpg",
  "answers": [
    { "text": "George Washington", "score": 1 },
    { "text": "Thomas Jefferson", "score": 0 }
  ]
}
```

Legacy alias is also supported:

```json
{
  "image": "assets/question_images/usa/famous_people/george_washington.jpg"
}
```

## Recommended folder structure

- `assets/question_images/{country}/{category}/{file}.jpg`
- `assets/question_images/{country}/{region}/{category}/{file}.jpg`

## Notes

- Paths must be valid Flutter asset paths.
- If the image is missing or broken, quiz UI silently hides the image block.
- Existing questions without `imageAsset` continue to work with no changes.

You may have already learned how to set text color in [Text Color · CSSKatas](https://csskatas.com/katas/text-color).
But what if the text becomes fancier, and has a gradient color instead?

CSS doesn't support setting a gradient color to text.
But with Tailwind, we can easily achieve this effect.

The trick is that we can set an element's background to a linear gradient image.\
Then crop the background to match the shape of the text.\
Finally, we set the text color to transparent.\
So the text would use the background image, which is gradient!

Check these docs for more details:
- [Background Image - Tailwind CSS](https://tailwindcss.com/docs/background-image)
- [Gradient Color Stops - Tailwind CSS](https://tailwindcss.com/docs/gradient-color-stops)
- [Background Clip - Tailwind CSS](https://tailwindcss.com/docs/background-clip)

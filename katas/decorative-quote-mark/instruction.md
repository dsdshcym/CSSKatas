We often see these decorative quote marks in modern web designs.

To make our own decorative texts with Tailwind CSS, the trick is to put them in
a position relative to the major texts.

Use `relative` class to make the parent `div` a position reference.\
Then we can add `absolute` and `top-*`/`left-*`/`right-*`/`bottom-*` classes to position a child `div` anywhere inside the parent `div`.

Check these docs for more details:
- [Position (relative) - Tailwind CSS](https://tailwindcss.com/docs/position#relative)
- [Position (absolute) - Tailwind CSS](https://tailwindcss.com/docs/position#absolute)
- [Top / Right / Bottom / Left - Tailwind CSS](https://tailwindcss.com/docs/top-right-bottom-left)

---

<!-- TODO:  -->
With Tailwind JIT, you may also use `::before` pseudo element to achieve the same effect.\
Check out [What's New in Tailwind CSS v2.2 - YouTube](https://youtu.be/DxcJbrs6rKk?t=445) to learn this trick.

Unfortunately, CSSKatas doesn't support JIT yet.\
So please remember to subscribe to the CSSKata newsletter to get notified when we add JIT support.\
And come back to this Kata then!


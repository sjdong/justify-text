# justify-text
Flutter 中，Text组件的textAlign: TextAlign.justify对中文无效，考虑到中文的特征是可以随意截断而不影响语义和阅读的，因此考虑使用每行一个Text的方式，然后通过调整单行的letterspacing来达到justify的效果，而且，基于APP开发来说，一页所展示的全量文本行数也比较有限，总体的widgets数量上来说，也不会导致性能问题。

这个思路的解决核心就是计算单行文本的所占用的字数，然后做截断，通过google后在stackoverflow上找到了TextPainter方法
[https://stackoverflow.com/questions/52659759/how-can-i-get-the-size-of-the-text-widget-in-flutter]。
而且github上也已经有人用这个方式通过canvas来解决这个问题。考虑到那个例子是用来解决阅读器的，而在非阅读器类的应用场景下(比如文章列表，wrap信息流等)，text的布局会存在多样化，因此都使用CustomPainter的话担心可能会导致性能问题，所以决定用widget的方式来解决。

该方案仅支持中文，英文或者中英文混编的可以在此基础上进行修改：

英文修改思路：计算出字符长度后，判断前一位是否是空格：是，则截断到前一位，否则截断到前一个空格

混编修改思路：判断截断前一个字符是否属于a-z，是则往前找到非字母位置进行截断。可以针对截断的字符串使用正则表达式获取match，将最后下标的match剔除，合并到原字符串继续处理。

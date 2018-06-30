(in-package :cl-user)
(defpackage flute.test
  (:use :cl :flute :fiveam))
(in-package :flute.test)

(def-suite builtin-element)
(def-suite escape)
(def-suite attr-access)
(def-suite user-element)

(in-suite builtin-element)

(test empty-attr
  (let* ((div1 (div))
         (div2 (div "the children text"))
         (div3 (div "text 1" "text 2"))
         (div4 (div (h1 "text 0") "text 01"
                    (list (list "text 3" div2) div3) "text 4")))
    (is (eql nil (attrs-alist (element-attrs div1))))
    (is (eql nil (element-children div1)))
    (is (eql nil (attrs-alist (element-attrs div2))))
    (is (equal (list "the children text") (element-children div2)))
    (is (eql nil (attrs-alist (element-attrs div3))))
    (is (equal (list "text 1" "text 2") (element-children div3)))
    (is (eql nil (attrs-alist (element-attrs div4))))
    (is (= 6 (length (element-children div4))))
    (let ((child1 (first (element-children div4)))
          (child2 (second (element-children div4)))
          (child3 (third (element-children div4)))
          (child4 (fourth (element-children div4)))
          (child5 (fifth (element-children div4)))
          (child6 (sixth (element-children div4))))
      (is (equal "h1" (element-tag child1)))
      (is (equal "text 01" child2))
      (is (equal "text 3" child3))
      (is (eql div2 child4))
      (is (eql div3 child5))
      (is (equal "text 4" child6)))))

(test attr-given-by-inline-args
  (let* ((div1 (div :id "container"))
         (div2 (div :id "cat" :class "happy"))
         (div3 (div :id "container" "some children text" div1))
         (div4 (div :id "dog" :class "happy" (list (list div1) div2) (list div3))))
    (is (equal '((:id . "container")) (attrs-alist (element-attrs div1))))
    (is (eql nil (element-children div1)))
    (is (equal '((:id . "cat") (:class . "happy")) (attrs-alist (element-attrs div2))))
    (is (eql nil (element-children div2)))
    (is (equal '((:id . "container")) (attrs-alist (element-attrs div3))))
    (is (equal (list "some children text" div1) (element-children div3)))
    (is (equal '((:id . "dog") (:class . "happy")) (attrs-alist (element-attrs div4))))
    (is (equal (list div1 div2 div3) (element-children div4)))))

(test attr-given-by-attrs
  (let* ((div00 (div (make-attrs)))
         (div01 (div (make-attrs :alist nil) "some text"))
         (div1 (div (make-attrs :alist '((:id . "container")))))
         (div2 (div (make-attrs :alist '((:id . "cat") (:class . "happy")))))
         (div3 (div (make-attrs :alist '((:id . "container"))) "some children text" div1))
         (div4 (div (make-attrs :alist '((:id . "dog") (:class . "happy"))) (list (list div1) div2) (list div3))))
    (is (eql nil (attrs-alist (element-attrs div00))))
    (is (eql nil (element-children div00)))
    (is (eql nil (attrs-alist (element-attrs div01))))
    (is (equal (list "some text") (element-children div01)))
    (is (equal '((:id . "container")) (attrs-alist (element-attrs div1))))
    (is (eql nil (element-children div1)))
    (is (equal '((:id . "cat") (:class . "happy")) (attrs-alist (element-attrs div2))))
    (is (eql nil (element-children div2)))
    (is (equal '((:id . "container")) (attrs-alist (element-attrs div3))))
    (is (equal (list "some children text" div1) (element-children div3)))
    (is (equal '((:id . "dog") (:class . "happy")) (attrs-alist (element-attrs div4))))
    (is (equal (list div1 div2 div3) (element-children div4)))))

(test attr-given-by-alist
  (let* ((div00 (div nil))
         (div01 (div nil "some text"))
         (div1 (div '((:id . "container"))))
         (div2 (div '((:id . "cat") (:class . "happy"))))
         (div3 (div '((:id . "container")) "some children text" div1))
         (div4 (div '((:id . "dog") (:class . "happy")) (list (list div1) div2) (list div3))))
    (is (eql nil (attrs-alist (element-attrs div00))))
    (is (eql nil (element-children div00)))
    (is (eql nil (attrs-alist (element-attrs div01))))
    (is (equal (list "some text") (element-children div01)))
    (is (equal '((:id . "container")) (attrs-alist (element-attrs div1))))
    (is (eql nil (element-children div1)))
    (is (equal '((:id . "cat") (:class . "happy")) (attrs-alist (element-attrs div2))))
    (is (eql nil (element-children div2)))
    (is (equal '((:id . "container")) (attrs-alist (element-attrs div3))))
    (is (equal (list "some children text" div1) (element-children div3)))
    (is (equal '((:id . "dog") (:class . "happy")) (attrs-alist (element-attrs div4))))
    (is (equal (list div1 div2 div3) (element-children div4)))))

(test attr-given-by-plist
  (let* ((div00 (div nil))
         (div01 (div nil "some text"))
         (div1 (div '(:id "container")))
         (div2 (div '(:id "cat" :class "happy")))
         (div3 (div '(:id "container") "some children text" div1))
         (div4 (div '(:id "dog" :class "happy") (list (list div1) div2) (list div3))))
    (is (eql nil (attrs-alist (element-attrs div00))))
    (is (eql nil (element-children div00)))
    (is (eql nil (attrs-alist (element-attrs div01))))
    (is (equal (list "some text") (element-children div01)))
    (is (equal '((:id . "container")) (attrs-alist (element-attrs div1))))
    (is (eql nil (element-children div1)))
    (is (equal '((:id . "cat") (:class . "happy")) (attrs-alist (element-attrs div2))))
    (is (eql nil (element-children div2)))
    (is (equal '((:id . "container")) (attrs-alist (element-attrs div3))))
    (is (equal (list "some children text" div1) (element-children div3)))
    (is (equal '((:id . "dog") (:class . "happy")) (attrs-alist (element-attrs div4))))
    (is (equal (list div1 div2 div3) (element-children div4)))))

(in-suite escape)

(defparameter *a-attrs*
  '((:id . "nothing-to-escape")
    (:class . "something-with-\"-in-value")
    (:href . "http://localhost:3000/id=3&name=foo")
    (:data . "'<>")))

(defun new-a ()
  (a *a-attrs*
     "child text 1"
     "child text 2 <br> &"
     (a :href "child'<>\".html" "child'<>\"" (string (code-char 128)))
     (string (code-char 128))))

(test escape-attr
  (let ((escaped-attrs-alist '((:id . "nothing-to-escape")
                               (:class . "something-with-&quot;-in-value")
                               (:href . "http://localhost:3000/id=3&name=foo")
                               (:data . "'<>")) ))
    (is (equal escaped-attrs-alist (attrs-alist (element-attrs (new-a)))))
    (let ((*escape-html* nil))
      (is (equal *a-attrs* (attrs-alist (element-attrs (new-a))))))
    (let ((*escape-html* :attr))
      (is (equal escaped-attrs-alist (attrs-alist (element-attrs (new-a))))))
    (let ((*escape-html* :ascii))
      (is (equal escaped-attrs-alist (attrs-alist (element-attrs (new-a))))))))

(test escape-children
  (let ((a (new-a)))
    (is (string= "child text 1" (first (element-children a))))
    (is (string= "child text 2 &lt;br&gt; &amp;" (second (element-children a))))
    (is (string= "child'<>&quot;.html" (attr (element-attrs (third (element-children a))) :href)))
    (is (string= "child'&lt;&gt;\"" (first (element-children (third (element-children a))))))
    (is (string= (string (code-char 128)) (second (element-children (third (element-children a))))))
    (is (string= (string (code-char 128)) (fourth (element-children a)))))
  (let* ((*escape-html* :ascii)
         (a (new-a)))
    (is (string= "child text 1" (first (element-children a))))
    (is (string= "child text 2 &lt;br&gt; &amp;" (second (element-children a))))
    (is (string= "child'<>&quot;.html" (attr (element-attrs (third (element-children a))) :href)))
    (is (string= "child'&lt;&gt;\"" (first (element-children (third (element-children a))))))
    (is (string= "&#128;" (second (element-children (third (element-children a))))))
    (is (string= "&#128;" (fourth (element-children a))))))

(in-suite attr-access)

(test attr-get
  (is (eql nil (attr (a) :id)))
  (is (eql nil (attr (new-a) :foo)))
  (is (equal "nothing-to-escape" (attr (new-a) :id)))
  (is (equal "'<>" (attr (element-attrs (new-a)) :data))))

(test attr-set
  (let ((a (new-a)))
    (setf (attr a :id) "a")
    (setf (attr a :foo) "b")
    (setf (attr (element-attrs a) :class) "c")
    (setf (attr (element-attrs a) :bar) "d")
    (is (equal "a" (attr a :id)))
    (is (equal "b" (attr a :foo)))
    (is (equal "c" (attr a :class)))
    (is (equal "d" (attr a :bar)))))

(test attr-delete
  (let ((a (new-a)))
    (delete-attr a :id)
    (delete-attr a :foo)
    (delete-attr a :class)
    (delete-attr (element-attrs a) :bar)
    (delete-attr a :href)
    (is (equal '((:data . "'<>")) (attrs-alist (element-attrs a))))))

(in-suite user-element)

(define-element cat ()
  (div :id "cat"
       (img :src "cat.png")
       "I'm a cat"))

(test user-element-simple
  (let ((cat (cat)))
    (is (string= "cat" (attr (user-element-expand-to cat) :id)))
    (is (string= "cat.png" (attr (first (element-children (user-element-expand-to cat))) :src)))
    (is (string= "I'm a cat" (car (last (element-children (user-element-expand-to cat))))))))

(define-element dog (id size)
  (if (and (realp size) (> size 10))
      (div :id id :class "big-dog"
       children
       "dog")
      (div :id id :class "small-dog"
       children
       "dog")))

(test user-element-with-attrs
  (let ((dog1 (dog))
        (dog2 (dog :size 15))
        (dog3 (dog (img :src "dog.png")))
        (dog4 (dog :id "dog" :size 10 (img :src "dog4.png") "woo")))
    (is (eql nil (attrs-alist (element-attrs dog1))))
    (is (string= "dog" (first (element-children (user-element-expand-to dog1)))))
    (is (string= "small-dog" (attr (user-element-expand-to dog1) :class)))
    (is (eql nil (element-children dog1)))
    (is (string= "dog" (element-tag dog1)))

    (is (equal '((:size . 15)) (attrs-alist (element-attrs dog2))))
    (is (equal '((:class . "big-dog")) (attrs-alist (element-attrs (user-element-expand-to dog2)))))
    (is (string= "dog" (first (element-children (user-element-expand-to dog2)))))
    (is (eql nil (element-children dog2)))

    (is (eql nil (attrs-alist (element-attrs dog3))))
    (is (string= "dog" (second (element-children (user-element-expand-to dog3)))))
    (is (string= "dog.png" (attr (first (element-children (user-element-expand-to dog3))) :src)))
    (is (string= "dog.png" (attr (first (element-children dog3)) :src)))

    (is (equal '((:id . "dog") (:size . 10)) (attrs-alist (element-attrs dog4))))
    (is (= 10 (attr dog4 :size)))
    (is (string= "img" (element-tag (first (element-children dog4)))))
    (is (string= "dog4.png" (attr (first (element-children (user-element-expand-to dog4))) :src)))
    (is (string= "woo" (second (element-children dog4))))

    (setf (attr dog4 :size) 16)
    (is (= 16 (attr dog4 :size)))
    (is (string= "big-dog" (attr (user-element-expand-to dog4) :class)))))

(run-all-tests)

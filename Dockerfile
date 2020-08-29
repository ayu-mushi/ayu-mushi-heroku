FROM haskell:8.8.3

WORKDIR /work

COPY stack.yaml package.yaml /work/
RUN stack build --only-dependencies

COPY . /work/
RUN stack build -j1 && stack install

CMD ayu-mushi-scrapbox-exe -p $PORT
